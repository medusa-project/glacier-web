class CreateArchiveFileInfoJoins < ActiveRecord::Migration[5.0]
  def change
    create_table :archive_file_info_joins do |t|
      t.references :archive, foreign_key: true, index: false, null: false
      t.references :file_info, foreign_key: true, index: true, null: false
    end
    add_index :archive_file_info_joins, [:archive_id, :file_info_id], unique: true
  end
end
