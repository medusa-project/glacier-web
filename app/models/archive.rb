class Archive < ApplicationRecord
  belongs_to :root
  has_many :archive_file_info_joins, dependent: :destroy
  has_many :file_infos, through: :archive_file_info_joins
  has_one :job_archive_backup, :class_name => 'Job::ArchiveBackup'

  after_create :create_archive_backup_job

  def create_archive_backup_job
    Job::ArchiveBackup.create_for(self)
  end

  def send_backup_request_message
    AmqpHelper::Connector[:default].send_message(Settings.amqp.outgoing_queue, backup_request_message)
  end

  def backup_request_message
    {action: 'backup', archive_id: id, root_path: root.path, manifest_path: manifest_path}
  end

  def manifest_path
    "archive_#{id}.txt"
  end

end
