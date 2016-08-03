class CreateFileInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :file_infos do |t|
      t.references :root, foreign_key: true
      t.text :path, null: false
      t.decimal :size, null: false
      t.integer :mtime, null: false
      t.boolean :needs_archiving, null: false, default: true
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :file_infos, :path
    add_index :file_infos, :needs_archiving
    add_index :file_infos, :deleted
    add_index :file_infos, [:root_id, :path], unique: true
  end
end
