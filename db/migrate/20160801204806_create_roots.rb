class CreateRoots < ActiveRecord::Migration[5.0]
  def change
    create_table :roots do |t|
      t.string :path, null: false
      t.timestamps
    end
    add_index :roots, :path, unique: true
  end
end
