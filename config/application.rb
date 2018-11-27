# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'net/http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Currency
  class Application < Rails::Application
    config.load_defaults 5.2

    config.active_record.default_timezone = :utc

    config.generators do |g|
      g.test_framework false
      g.stylessheets   false
      g.javascripts    false
      g.helper         false
      g.channel        assets: false
    end
  end
end
