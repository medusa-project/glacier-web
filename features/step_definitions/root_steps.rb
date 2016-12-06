require 'fileutils'

When(/^I request the list of roots$/) do
  visit roots_path
end

Given(/^the root with path '(.*)' exists$/) do |path|
  FactoryGirl.create(:root, path: path)
end

Given(/^the root with path '(.*)' has archives with fields:$/) do |path, table|
  root = Root.find_by(path: path)
  table.hashes.each do |hash|
    root.archives.create(hash)
  end
end

When(/^I request the list of archives for the root with path '([^']*)'$/) do |path|
  visit archives_roots_path(path: path)
end

When(/^I request the list of archives for the root with path '(.*)' and file with path '(.*)'$/) do |root_path, file_path|
  visit archives_for_file_roots_path(root_path: root_path, file_path: file_path)
end

When(/^I create a root with path '(.*)'$/) do |path|
  page.driver.post roots_path, path: path
end


And(/^the root with path '(.*)' has a backup job in state '(.*)'$/) do |path, state|
  root = Root.find_by(path: path)
  backup_job = root.job_root_backup || root.create_job_root_backup(state: state)
  backup_job.state = state
  backup_job.save!
end

And(/^the root with path '(.*)' has db and manifest file information:$/) do |path, table|
  root = Root.find_by(path: path)
  root.path_translator_root.ensure_local_path_to('')
  # table is a table.hashes.keys # => [:path, :size, :fs_mtime, :db_mtime]
  File.open(PathTranslator::RootSet[:manifests].local_path_to(root.manifest_path), 'w') do |manifest|
    table.hashes.each do |hash|
      if hash[:db_mtime].present?
        root.file_infos.create!(path: hash[:path], size: hash[:size], mtime: hash[:db_mtime],
                                deleted: hash[:deleted], needs_archiving: false)
      end
      if hash[:fs_mtime].present?
        manifest.puts "#{hash[:path]} #{hash[:size]} #{hash[:fs_mtime]}"
      end
    end
  end
end

Then(/^the backup job for the root with path '(.*)' should be in state '(.*)'$/) do |path, state|
  expect(Root.find_by(path: path).job_root_backup.state).to eq(state)
end


And(/^the root with path '(.*)' has files with fields:$/) do |path, table|
  root = Root.find_by(path: path)
  table.hashes.each do |file_info|
    FactoryGirl.create(:file_info, file_info.merge(root_id: root.id))
  end
end


Then(/^the root with path '(.*)' should have archives with fields:$/) do |path, table|
  root = Root.find_by(path: path)
  table.hashes.each do |hash|
    expect(root.archives.find_by(hash)).to be_truthy
  end
end

Given(/^there are roots with fields:$/) do |table|
  table.hashes.each do |root|
    FactoryGirl.create(:root, root)
  end
end

And(/^the root backup job for the root with path '(.*)' should have a stored message$/) do |path|
  expect(Root.find_by(path: path).job_root_backup.message).to be_truthy
end