And(/^there should be a job to backup the root with path '(.*)'$/) do |path|
  expect(Root.find_by(path: path).job_root_backup).to be_a(Job::RootBackup)
end