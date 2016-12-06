class AddMessageToJobArchiveBackups < ActiveRecord::Migration[5.0]
  def change
    add_column :job_archive_backups, :message, :text
  end
end
