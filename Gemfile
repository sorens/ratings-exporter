source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem "SystemTimer", :require => "system_timer", :platforms => :ruby_18
gem "rack-timeout"
gem 'pg'
gem 'rake'
gem 'jquery-rails'
gem 'rest-client'
gem 'nokogiri'
gem 'oauth'
gem 'delayed_job',          "~> 2.1.4"
gem 'less-rails-bootstrap', "~> 1.4.0"
gem 'activeadmin'
gem 'sass-rails',     "~> 3.1.0"
gem 'meta_search',    '>= 1.1.0.pre'
gem 'fastercsv'
gem 'thin'
gem 'newrelic_rpm'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  gem 'workless', :git => "git://github.com/christophercotton/workless"
end
