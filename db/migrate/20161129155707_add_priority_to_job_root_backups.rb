class AddPriorityToJobRootBackups < ActiveRecord::Migration[5.0]
  def change
    add_column :job_root_backups, :priority, :string, index: true, null: false
  end
end
