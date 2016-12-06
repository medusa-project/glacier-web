source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'pg', '~> 0.18'
#need for large result sets with ordering (not available with find_each)
gem 'postgresql_cursor'

gem 'passenger'
gem 'jbuilder'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'daemons-rails'
gem 'amqp_helper', '~>0.1.4', git: 'git://github.com/medusa-project/amqp_helper.git'
gem 'path_translator', git: 'git@github.com:medusa-project/path_translator.git'
gem 'config'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'shoulda-matchers'
end

group :development do
  gem 'listen', '~> 3.0.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'json_spec'
  gem 'capybara'
  gem 'capybara-email'
  #awaiting fix on canonical bunny-mock to make the default exchange deliver messages
  gem 'bunny-mock', git: 'git://github.com/hading/bunny-mock.git'
end