class Root < ApplicationRecord
  has_many :archives, dependent: :destroy
  has_one :job_root_backup, :class_name => 'Job::RootBackup', dependent: :destroy

  after_create :create_initial_backup_job

  def create_initial_backup_job
    self.create_job_root_backup!
  end

end
