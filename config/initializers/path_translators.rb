require_relative 'config.rb'
require 'fileutils'

PathTranslator::RootSet.add_root(:storage, Settings.storage_root)
PathTranslator::RootSet.add_root(:manifests, Settings.manifests_root)

unless Rails.env.production?
  FileUtils.mkdir_p(Settings.storage_root)
  FileUtils.mkdir_p(Settings.manifests_root)
end
