Given(/^the storage path '(.*)' exists$/) do |path|
  PathTranslator::RootSet[:storage].ensure_local_path_to(path)
end