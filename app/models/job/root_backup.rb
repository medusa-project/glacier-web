require 'csv'
class Job::RootBackup < Job::Base
  belongs_to :root

  STATES = %w(start request_manifest wait_manifest process_manifest
    create_archives finish)
  validates_inclusion_of :state, in: STATES, allow_blank: false
  PRIORITIES = %w(normal high)
  validates_inclusion_of :priority, in: PRIORITIES, allow_blank: false


  def self.create_for(root, priority: 'normal')
    job = self.create!(root: root, priority: priority, state: 'start')
    job.put_in_queue
  end

  def self.queue
    'root_backup'
  end

  #Basic idea:
  #If the file was marked deleted and is present again in the manifest or if it is not deleted
  #but the mtime or size has changed then we update it.
  #If the file was in the manifest but not in the file info table then we add it
  #If the file is in the file info table but not the manifest then we mark it as deleted
  #This method is just a way of doing that efficiently using the database.
  def perform_process_manifest
    create_temp_table
    copy_manifest
    augment_temp_table
    update_changed_and_recreated
    insert_new
    update_deleted
    remove_manifest
    put_in_queue(new_state: 'create_archives')
  ensure
    drop_temp_table
  end

  def perform_create_archives
    archives = Array.new
    fileset = Array.new
    total_size = 0
    x = root.file_infos.to_a
    root.file_infos.where(needs_archiving: true).order('size desc').each_instance do |file|
      fileset << file.id
      total_size += file.size
      if total_size > Settings.archive_size_limit
        archives << create_archive(fileset, total_size)
        fileset = Array.new
        total_size = 0
      end
    end
    archives << create_archive(fileset, total_size) if fileset.present?
    archives.each { |archive| Job::ArchiveBackup.create_for(archive) }
    put_in_queue(new_state: 'finish')
  end

  def perform_start
    put_in_queue(new_state: 'request_manifest')
  end

  def perform_finish
    self.destroy!
  end

  protected

  def temp_table_name
    "temp_file_info_#{id}"
  end

  def csv_file_name
    File.join(Dir.tmpdir, "manifest_#{id}.csv")
  end

  def connection
    self.class.connection
  end

  def create_temp_table
    drop_temp_table
    connection.create_table temp_table_name do |t|
      t.text :path
      t.decimal :ext_size
      t.integer :ext_mtime
    end
  end

  def copy_manifest
    CSV.open(csv_file_name, 'w') do |csv|
      with_manifest_data do |path, size, mtime|
        csv << [path, size, mtime]
      end
    end
    sql = %Q(COPY #{temp_table_name} (path, ext_size, ext_mtime) FROM '#{csv_file_name}' WITH CSV)
    connection.execute(sql)
  ensure
    File.delete(csv_file_name) if File.exist?(csv_file_name)
  end

  def augment_temp_table
    connection.add_index temp_table_name, :path
    connection.add_column temp_table_name, :int_mtime, :integer
    connection.add_column temp_table_name, :int_size, :decimal
    connection.add_column temp_table_name, :int_deleted, :boolean
    sql = <<SQL
      UPDATE #{temp_table_name} T
      SET int_mtime = F.mtime, int_size = F.size, int_deleted = F.deleted
      FROM file_infos F
      WHERE F.root_id = #{root.id}
      AND F.path = T.path
      ;
      ANALYZE #{temp_table_name}
SQL
    connection.execute(sql)
  end

  def update_changed_and_recreated
    sql = <<SQL
      UPDATE file_infos F
      SET mtime = T.ext_mtime, size = T.ext_size,
          deleted = false, needs_archiving = true
      FROM #{temp_table_name} T
      WHERE F.root_id = #{root.id}
      AND F.path = T.path
      AND T.int_mtime IS NOT NULL
      AND (T.int_deleted = true OR T.int_mtime != T.ext_mtime OR T.int_size != T.ext_size)
SQL
    connection.execute(sql)
  end

  def insert_new
    sql = <<SQL
      INSERT INTO file_infos (root_id, path, size, mtime, needs_archiving, deleted, created_at, updated_at)
      SELECT #{root.id}, F.path, F.ext_size, F.ext_mtime, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM #{temp_table_name} F
      WHERE f.int_mtime IS NULL
SQL
    connection.execute(sql)
  end

  def update_deleted
    sql = <<SQL
      UPDATE file_infos F
      SET deleted = true, needs_archiving = false
      FROM (file_infos FI LEFT JOIN #{temp_table_name} TI ON FI.path = TI.path )
      WHERE F.root_id = #{root.id}
      AND F.path = FI.path
      AND TI.ext_size IS NULL
SQL
    connection.execute(sql)
  end

  def drop_temp_table
    connection.drop_table temp_table_name, if_exists: true
  end

  #TODO perhaps archive these instead of removing them
  def remove_manifest
    File.delete(manifest_path) if File.exist?(manifest_path)
  end

  def manifest_path
    raise RuntimeError, "Manifest not found for Job::RootBackup #{id}" unless self.manifest.present?
    PathTranslator::RootSet[:manifests].local_path_to(manifest).tap do |manifest_file|
      raise RuntimeError, "Manifest file not found for Job::RootBackup #{id}" unless File.exist?(manifest_file)
    end
  end

  def with_manifest_data
    File.open(manifest_path) do |f|
      f.each_line do |line|
        line.chomp.match(/^(.*)\s+(\d+)\s+(\d+)$/)
        yield $1, $2.to_i, $3.to_i
      end
    end
  end

  #fileset is an array of file info ids
  def create_archive(fileset, size)
    root.archives.create!(count: fileset.count, size: size).tap do |archive|
      archive.file_info_ids = fileset
      archive.file_infos.update_all(needs_archiving: false)
    end
  end

end



