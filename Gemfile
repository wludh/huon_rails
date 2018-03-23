source 'https://rubygems.org'
ruby '2.2.3'
# gem 'annotator_store'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'

# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'sqlite3'
end

gem 'roman-numerals'

gem 'rspec-rails', '~> 3.1.0', group: [:development, :test]
gem 'capybara', group: [:development, :test]
gem 'selenium-webdriver', group: [:development, :test]
gem 'puma'

gem 'will_paginate', '~> 3.0.5'
gem 'i18n'

gem 'simplecov', :require => false, :group => :test

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'nokogiri'
gem 'barista'
gem 'therubyracer', :require => nil

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'travis'