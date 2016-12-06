class DeleteManifestFromJobRootBackups < ActiveRecord::Migration[5.0]
  def change
    remove_column :job_root_backups, :manifest
  end
end
