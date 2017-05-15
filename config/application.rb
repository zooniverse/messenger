require_relative 'boot'

require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'
Bundler.require(*Rails.groups)

module Messenger
  class Application < Rails::Application
    attr_accessor :revision

    config.api_only = true

    config.autoload_paths += [
      'lib',
      'app/policies/concerns',
      'app/policies',
      'app/schemas/concerns',
      'app/schemas',
      'app/serializers/concerns',
      'app/serializers',
      'app/services/concerns',
      'app/services',
    ].collect{ |path| Rails.root.join path }

    config.action_controller.permit_all_parameters = true
  end
end
