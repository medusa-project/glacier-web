class Job::ArchiveBackup < Job::Base
  belongs_to :archive
  serialize :message

  STATES = %w(start create_manifest send_request await_response process_response finish)
  validates_inclusion_of :state, in: STATES, allow_blank: false
  validates_uniqueness_of :archive_id

  def self.create_for(archive)
    job = self.create!(archive_id: archive.id, state: 'start')
    job.put_in_queue
  end

  def self.queue
    'archive_backup'
  end

  def perform_send_request
    archive.send_backup_request_message
    put_in_queue(new_state: 'await_response')
  end

end
