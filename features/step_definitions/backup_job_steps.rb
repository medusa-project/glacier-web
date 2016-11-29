And(/^there should be a job to backup the root with path '(.*)'$/) do |path|
  expect(Root.find_by(path: path).job_root_backup).to be_a(Job::RootBackup)
end

When(/^I request backup for the root with path '(.*)'$/) do |path|
  page.driver.post job_root_backups_path, path: path
end

Then(/^the backup job for the root with path '(.*)' should have priority '(.*)'$/) do |path, priority|
  root = Root.find_by(path: path)
  expect(root.job_root_backup.priority).to eq(priority)
end

Given(/^there is a backup job for the root with path '(.*)' with priority '(.*)'$/) do |path, priority|
  root = Root.find_by(path: path)
  root.job_root_backup || root.create_job_root_backup(state: 'start', priority: priority)
end

Given(/^there is no backup job for the root with path '(.*)'$/) do |path|
  Root.find_by(path: path).job_root_backup.try(:destroy)
end