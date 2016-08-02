class CreateArchives < ActiveRecord::Migration[5.0]
  def change
    create_table :archives do |t|
      t.references :root, foreign_key: true
      t.integer :count
      t.decimal :size

      t.timestamps
    end
  end
end
