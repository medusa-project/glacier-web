class AddAmazonArchiveIdToArchives < ActiveRecord::Migration[5.0]
  def change
    add_column :archives, :amazon_archive_id, :string
    add_index :archives, :amazon_archive_id
  end
end
