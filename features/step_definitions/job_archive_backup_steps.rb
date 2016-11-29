And(/^there should be (\d+) archive backup jobs$/) do |count|
  expect(Job::ArchiveBackup.count).to eq(count.to_i)
end