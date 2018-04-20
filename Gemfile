source 'https://gems.ruby-china.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'settingslogic'

# RequestStore gives you per-request global storage.
gem 'request_store', '~> 1.4', '>= 1.4.1'

# Makes http fun! Also, makes consuming restful web services dead easy.
gem 'httparty', '~> 0.16', '>= 0.16.2'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.0', '>= 1.0.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano-rails', '~> 1.3', '>= 1.3.1'
  gem 'capistrano3-unicorn', '~> 0.2', '>= 0.2.1'
  gem 'capistrano-rvm', '~> 0.1', '>= 0.1.2'
  gem 'capistrano-sidekiq', '~> 1.0.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Use unicorn as the app server
group :production do
  # unicorn is an HTTP server for Rack applications designed to only serve fast
  # clients on low-latency, high-bandwidth connections and take advantage of
  # features in Unix/Unix-like kernels.
  gem 'unicorn', '~> 5.4', '>= 5.4.0'
  # raindrops is a real-time stats toolkit to show statistics
  # for Rack HTTP servers.
  gem 'raindrops', '~> 0.19', '>= 0.19.0'
  # Kill unicorn workers by memory and request counts
  gem 'unicorn-worker-killer', '~> 0.4', '>= 0.4.4'
  # New Relic is a performance management system,
  # developed by New Relic, Inc (http://www.newrelic.com)
  gem 'newrelic_rpm', '~> 5.0', '>= 5.0.0.342'
end
