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
    {action: 'backup', archive_id: id, root_path: root.path, manifest_name: manifest_name}
  end

  def manifest_name
    "archive_#{id}.txt"
  end

  def bag_manifest_name
    "archive_bag_#{id}.txt"
  end

  def archive_manifests
    FileUtils.mkdir_p(attic_path)
    FileUtils.move(manifest_path, archived_manifest_path)
    FileUtils.move(bag_manifest_path, archived_bag_manifest_path)
  end

  def manifest_path
    File.join(Settings.manifests_root, manifest_name)
  end

  def bag_manifest_path
    File.join(Settings.manifests_root, bag_manifest_name)
  end

  def archived_manifest_path
    File.join(attic_path, manifest_name)
  end

  def archived_bag_manifest_path
    File.join(attic_path, bag_manifest_name)
  end

  def attic_path
    File.join(Settings.manifests_root, 'attic')
  end

end
