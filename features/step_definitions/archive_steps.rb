When(/^I request the archive with id (\d+)$/) do |id|
  visit archive_path(Archive.find(id))
end

When(/^I request the list of archives$/) do
  visit archives_path
end