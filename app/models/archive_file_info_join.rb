class ArchiveFileInfoJoin < ApplicationRecord
  belongs_to :archive
  belongs_to :file_info

  validates_uniqueness_of :file_info_id, scope: :archive_id
end