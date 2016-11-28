class FileInfo < ApplicationRecord
  belongs_to :root
  validates_uniqueness_of :path, scope: :root_id
  has_many :archive_file_info_joins, dependent: :destroy
  has_many :archives, through: :archive_file_info_joins
end
