class Job::RootBackupsController < ApplicationController

  def create
    root = Root.find_by(path: params[:path])
    if root
      if backup_job = root.job_root_backup
        @status = 'EXISTS'
        backup_job.priority = 'high'
        backup_job.save!
      else
        Job::RootBackup.create_for(root, priority: 'high')
        @status = 'CREATED'
      end
    else
      @status = 'BAD ROOT'
    end
  end

end