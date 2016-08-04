require 'set'
class Job::RootBackup < ApplicationRecord
  belongs_to :root

  STATES = %w(start request_manifest wait_manifest process_manifest
    create_archives finish)
  validates_inclusion_of :state, in: STATES

  def process
    call("process_#{self.state}")
  end

  #TODO - refactor to make nicer
  #TODO - this may need work for efficiency for large roots
  #See the end of this file for an idea
  def process_process_manifest
    #paths currently in the database
    existing_paths = root.file_infos.pluck(:path).to_set
    with_manifest_data do |path, size, mtime|
      #see if we have a record of this path
      if file_info = FileInfo.find_by(path: path)
        if file_info.deleted or file_info.mtime != mtime
          #the file was previously deleted and has reappeared
          #or has been modified. In either case the same action is needed.
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
    existing_paths.each do |path|
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

end


=begin
Processing manifest efficiency idea
For our largest current file group it may take a few GB
just to hold the path set, not to mention the time to
do the file_info queries and the updates.
Very rough estimates for 7000000 records using naive AR
read time ~ 1 hour
create time ~ 10 hours
update time ~ 6 hours
For contrast using copy I got about 10 minutes using a similar
test to do the create. Doing it without the index and then indexing was more
like 0.5m + 4m. Creating the CSV would take a
few more minutes. Regardless, much better.
Now, after the first time probably not too many creates or updates
will be done. But still...
However, we should be able to do the necessary operations
directly in the database with a little work.
Here's a sketch (check above code to make sure it's right if
actually implementing!):
1. Create a temporary table, say file_info_tmp_#{root_id} with
fields path, ext_size, ext_mtime
2. Convert the manifest into a form that postgres COPY can
import, perhaps in a new temp file
3. Use postgres COPY to insert the manifest data
4. Add index to path; add int_mtime and int_deleted columns. analyze table.

In a transaction:
5.(or 5a, 5b) Update file_infos where int_deleted = true or int_mtime != ext_mtime,
set mtime=ext_mtime, size=ext_size, deleted=false, needs_archiving = true
6. Where int_deleted IS NULL insert into file_infos
path=path, mtime-ext_mtime, size=ext_size,deleted=false, needs_archiving=true
7. Left Join file_infos to temp - where ext_size is null update
so that deleted = true, needs_archiving = false
End transaction

8. drop temporary table

We might make an ERB or whatever template that we can insert things like the
root_id into and feed that directly into pgsql. Or we could just make
the statements in code and execute them directly via ruby.

=end
