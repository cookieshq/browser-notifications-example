require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module BrowserNotificationsExample
  class Application < Rails::Application
    config.assets.quiet = true

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    config.action_controller.action_on_unpermitted_parameters = :raise

    config.assets.precompile << "service-worker.js"

    config.serviceworker.routes.draw do
      match "/service-worker.js"
    end
  end
end
