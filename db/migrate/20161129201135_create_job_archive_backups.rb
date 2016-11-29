class CreateJobArchiveBackups < ActiveRecord::Migration[5.0]
  def change
    create_table :job_archive_backups do |t|
      t.string :state
      t.string :manifest
      t.references :archive, foreign_key: true

      t.timestamps
    end
  end
end
