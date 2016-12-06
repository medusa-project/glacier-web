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