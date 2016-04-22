source "https://rubygems.org"

ruby "2.2.4"

gem "bourbon", "~> 3.2.1"
gem 'refills'
gem "coffee-rails"
gem "delayed_job_active_record"
gem "email_validator"
gem "flutie"
gem "high_voltage"
gem "i18n-tasks"
gem "jquery-rails"
gem "neat", "~> 1.5.1"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "rack-timeout"
gem "rails", "~> 4.2.0"
gem 'responders', '~> 2.0'
gem 'redcarpet'
gem "recipient_interceptor"
gem "sass-rails", "~> 4.0.3"
gem "simple_form"
gem "title"
gem "uglifier"
gem "unicorn"
gem "dce_lti", '~> 0.5.2'
gem 'activerecord-session_store', '~> 0.1.1'
gem 'browser', '~> 0.8.0'

group :development do
  gem 'quiet_assets'
end

group :development, :test do
  gem 'bundler-audit', require: false
  gem 'brakeman', require: false
  gem "awesome_print"
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.4.0"
end

group :test do
  gem "capybara-webkit", ">= 1.2.0"
  gem "database_cleaner"
  gem "launchy"
  gem "shoulda-matchers", "~> 2.8.0", require: false
  gem "timecop"
  gem "webmock"
  gem "simplecov", require: false
  gem 'rack_session_access'
end

group :staging, :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end
