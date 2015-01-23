ENV["RAILS_ENV"] = "test"
require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require 'rack_session_access/capybara'
require 'webmock/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

RSpec.configure do |config|
  WebMock.disable_net_connect!(allow_localhost: true)
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
  config.order = :random
end

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit
Capybara.default_wait_time = 5
