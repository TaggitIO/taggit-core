source 'https://rubygems.org'

ruby '2.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'
gem 'active_model_serializers'

# GitHub auth and interaction gems
gem 'omniauth-github'
gem 'octokit'

gem 'temescal'

# Mailing vendor gem
gem 'mandrill-api'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'pry-rails'
end

group :development, :test do
  # Use sqlite3 as the development and test databases
  gem 'sqlite3'
  gem 'awesome_print'
  gem 'debugger', '~> 1.6.5'
end

group :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'timecop'
  gem 'simplecov', require: false
  gem 'coveralls', require: false
end

group :production do
  # Use Postgres as the production database.
  gem 'pg'
  # Use unicorn as the app server
  gem 'unicorn'
  gem 'rails_12factor'
end
