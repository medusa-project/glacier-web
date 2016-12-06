class AddMessageToJobRootBackups < ActiveRecord::Migration[5.0]
  def change
    add_column :job_root_backups, :message, :text
  end
end
