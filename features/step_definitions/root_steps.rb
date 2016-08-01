When(/^I request the list of roots$/) do
  visit roots_path
end

Given(/^the root with path '(.*)' exists$/) do |path|
  FactoryGirl.create(:root, path: path)
end