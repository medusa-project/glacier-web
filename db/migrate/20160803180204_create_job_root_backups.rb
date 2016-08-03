class CreateJobRootBackups < ActiveRecord::Migration[5.0]
  def change
    create_table :job_root_backups do |t|
      t.references :root, foreign_key: true
      t.string :status, default: 'start', null: false

      t.timestamps
    end
    add_index :job_root_backups, :status
    remove_index :job_root_backups, :root_id
    add_index :job_root_backups, :root_id, unique: true
  end
end
