class Root < ApplicationRecord
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

end
