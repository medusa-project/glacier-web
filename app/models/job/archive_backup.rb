class Job::ArchiveBackup < Job::Base
  belongs_to :archive

  STATES = %w(start finish)
  validates_inclusion_of :state, in: STATES, allow_blank: false
  validates_uniqueness_of :archive_id

  def self.create_for(archive)
    job = self.create!(archive_id: archive.id, state: 'start')
    job.put_in_queue
  end

  def self.queue
    'archive_backup'
  end

end
