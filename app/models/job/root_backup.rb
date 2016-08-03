class Job::RootBackup < ApplicationRecord
  belongs_to :root

  STATES = %w(start request_manifest wait_manifest process_manifest
    create_archives finish)
  validates_inclusion_of :state, in: STATES

  def process
    call("process_#{self.state}")
  end

  #TODO - this may need work for efficiency for large roots
  #and perhaps we could refactor it regardless
  def process_process_manifest
    #paths currently in the database
    existing_paths = root.file_infos.pluck(:path, :mtime).to_h
    with_manifest_data do |path, size, mtime|
      #see if we have a record of this path
      if existing_mtime = existing_paths[path]
        file_info = FileInfo.find_by(path: path)
        #update if the mtime has changed
        if existing_mtime != file_info.mtime
          file_info.mtime = mtime
          file_info.size = size
          file_info.deleted = false
          file_info.needs_archiving = true
        else
          file_info.needs_archiving = false
        end
        file_info.save!
        #remove this path, as it has been handled
        existing_paths.delete(path)
      else
        #the path is new, so add a FileInfo
        root.file_infos.create!(path: path, size: size, mtime: mtime, deleted: false, needs_archiving: true)
      end
    end
    #remaining existing_paths were not in the manifest, so have
    #been deleted
    existing_paths.keys.each do |path|
      file_info = FileInfo.find_by(path: path)
      file_info.deleted = true
      file_info.needs_archiving = false
      file_info.save!
    end
    remove_manifest
    self.state = 'create_archives'
    save!
  end

  protected

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

end
