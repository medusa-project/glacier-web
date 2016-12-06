require 'fileutils'

When(/^I request the archive with id (\d+)$/) do |id|
  visit archive_path(Archive.find(id))
end

When(/^I request the list of archives$/) do
  visit archives_path
end

And(/^the archive with id '(.*)' contains the files with paths:$/) do |id, table|
  archive = Archive.find(id)
  root = archive.root
  table.headers.each do |path|
    file_info = root.file_infos.find_by(path: path)
    archive.file_infos << file_info
  end
end

When(/^I run the backup job for the archive with id '(.*)'$/) do |id|
  Archive.find(id).job_archive_backup.perform
end

And(/^the archive with id '(.*)' has manifest files$/) do |id|
  archive = Archive.find(id)
  FileUtils.touch(archive.manifest_path)
  FileUtils.touch(archive.bag_manifest_path)
end

And(/^the archive with id '(.*)' should have amazon archive id '(.*)'$/) do |id, amazon_archive_id|
  expect(Archive.find(id).amazon_archive_id).to eq(amazon_archive_id)
end

And(/^the archive with id '(.*)' should not have manifest files$/) do |id|
  archive = Archive.find(id)
  expect(File.exist?(archive.manifest_path)).to be_falsey
  expect(File.exist?(archive.bag_manifest_path)).to be_falsey
end

And(/^the archive with id '(.*)' should have archived manifest files$/) do |id|
  archive = Archive.find(id)
  expect(File.exist?(archive.archived_manifest_path)).to be_truthy
  expect(File.exist?(archive.archived_bag_manifest_path)).to be_truthy
end