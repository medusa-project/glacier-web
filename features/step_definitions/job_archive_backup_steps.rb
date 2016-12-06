And(/^there should be (\d+) archive backup jobs$/) do |count|
  expect(Job::ArchiveBackup.count).to eq(count.to_i)
end

Given(/^the archive backup job for the archive with id '(.*)' is in state '(.*)'$/) do |archive_id, state|
  job = Archive.find(archive_id).job_archive_backup
  job.state = state
  job.save!
end

And(/^the archive backup job for the archive with id '(.*)' should be in state '(.*)'$/) do |archive_id, state|
  job = Archive.find(archive_id).job_archive_backup
  expect(job.state).to eq(state)
end

And(/^the archive backup job for the archive with id '(.*)' should have a stored message$/) do |archive_id|
  expect(Archive.find(archive_id).job_archive_backup.message).to be_present
end