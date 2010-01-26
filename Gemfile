# directory "vendor/rails", :glob => "{*/,}*.gemspec"
# git "git://github.com/rails/arel.git"
# git "git://github.com/rails/rack.git"

clear_sources
bundle_path 'vendor/bundler_gems'
source 'http://gemcutter.org'
source 'http://gems.github.com'
disable_system_gems

gem 'rails', '2.3.5'
gem 'haml'
gem 'friendly_id'
gem 'resource_controller'
gem 'mysql'
gem 'delayed_job'
gem 'rest-client'
gem 'grit'

only :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'test-unit', '1.2.3'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'webrat'
  gem 'autotest-rails'
  gem 'spork'
end