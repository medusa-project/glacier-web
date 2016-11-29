class Job::Base < ApplicationRecord
  self.abstract_class = true
  delegate :queue, to: :class

  def self.queue
    raise RuntimeError, 'Subclass responsibility'
  end

  def put_in_queue(new_state: nil)
    if new_state
      self.state = new_state
      self.save!
    end
    Delayed::Job.enqueue(self, self.queue)
  end

  def perform
    call("perform_#{self.state}")
  end

end