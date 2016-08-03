require 'pathname'
[Settings.storage_root, Settings.manifests_root].each do |path|
  pathname = Pathname.new(path)
  Before do
    pathname.children.each {|entry| entry.rmtree}
  end
end