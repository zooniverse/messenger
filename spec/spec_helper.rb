ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'
require 'json/schema_builder/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # config.include RequestSpecHelper, type: :request
  config.include JSON::SchemaBuilder::RSpecHelper, type: :schema
  config.include FactoryGirl::Syntax::Methods

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite){ WebMock.disable_net_connect! }
  config.after(:suite){ WebMock.allow_net_connect! }

  config.alias_it_should_behave_like_to :it_has_behavior_of, 'has behavior:'
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
  config.filter_rails_from_backtrace!
  config.filter_run :focus
end

RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
