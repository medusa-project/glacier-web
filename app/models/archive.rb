class Archive < ApplicationRecord
  belongs_to :root
  has_many :archive_file_info_joins, dependent: :destroy
  has_many :file_infos, through: :archive_file_info_joins
end
