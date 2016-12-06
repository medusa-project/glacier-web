class Root < ApplicationRecord
  serialize :message

  has_many :archives, dependent: :destroy
  has_many :file_infos, dependent: :destroy
  has_one :job_root_backup, :class_name => 'Job::RootBackup', dependent: :destroy

  after_create :create_initial_backup_job

  def create_initial_backup_job
    Job::RootBackup.create_for(self)
  end

  def path_translator_root
    @path_translator_root ||= PathTranslator::RootSet[:storage].path_translator_root_to(self.path)
  end

  def send_backup_request_message
    AmqpHelper::Connector[:default].send_message(Settings.amqp.outgoing_queue, backup_request_message)
  end

  def backup_request_message
    {action: 'file_info', root_path: path, manifest_path: manifest_path}
  end

  def manifest_path
    "file_info_#{id}.txt"
  end

end
