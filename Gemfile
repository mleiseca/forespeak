source 'http://rubygems.org'

gem 'rails', '3.0.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'haml'
gem 'haml-rails'

gem 'jquery-rails'

gem 'authlogic'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'

gem 'nokogiri'

# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development do
	gem 'ruby-mysql', '2.9.3'

  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'rspec-rails'
  gem 'annotate-models', '1.0.4'
  gem 'faker', '0.3.1'
	# gem 'rails3-generators'
	
end


group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'webrat'
  gem 'autotest'
  gem "autotest-rails"
  gem 'factory_girl_rails', '1.0'
	gem "mocha"
	gem 'spork', '~> 0.9.0.rc'
end

group :production do
	gem 'mysql'
end

group :cucumber do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec-rails'
	gem 'spork', '~> 0.9.0.rc'
  gem 'launchy'    # So you can do Then show me the page
end


# gem 'newrelic_rpm'
