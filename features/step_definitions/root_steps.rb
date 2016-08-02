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

When(/^I request the list of archives for the root with path '(.*)'$/) do |path|
  visit archives_roots_path(path: path)
end

When(/^I create a root with path '(.*)'$/) do |path|
  page.driver.post roots_path, path: path
end
