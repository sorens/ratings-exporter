source 'http://rubygems.org'

gem 'rails', '3.2.2'
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
gem 'sass-rails',     '~> 3.2.3'
gem 'meta_search',    '>= 1.1.0.pre'
gem 'fastercsv'
gem 'thin'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  gem 'workless', :git => "git://github.com/christophercotton/workless"
end
