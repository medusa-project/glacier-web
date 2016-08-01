class CreateRoots < ActiveRecord::Migration[5.0]
  def change
    create_table :roots do |t|
      t.string :path

      t.timestamps
    end
  end
end
