class Job::ArchiveBackup < ApplicationRecord
  belongs_to :archive

  STATES = %w(start finish)
  validates_inclusion_of :state, in: STATES, allow_blank: false
  validates_uniqueness_of :archive_id

  def self.create_for(archive)
    job = self.create!(archive_id: archive.id, state: 'start')
    job.put_in_queue
  end

  def put_in_queue(new_state: nil)
    if new_state
      self.state = new_state
      self.save!
    end
    Delayed::Job.enqueue(self, queue: 'archive_backup')
  end

  def perform
    call("perform_#{self.state}")
  end

end
