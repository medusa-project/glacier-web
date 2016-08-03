class AddManifestToJobRootBackups < ActiveRecord::Migration[5.0]
  def change
    add_column :job_root_backups, :manifest, :string
    add_index :job_root_backups, :manifest, unique: true
  end
end
