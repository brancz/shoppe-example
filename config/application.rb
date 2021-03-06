require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'prometheus/middleware/exporter'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ExampleStore
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Add the prometheus client middleware.
    config.middleware.use Prometheus::Middleware::Exporter

    config.after_initialize do
	    $prometheus = Prometheus::Client.registry

      rails_up = Prometheus::Client::Gauge.new(:app_running, 'Rails app has started')
      $prometheus.register(rails_up)

      $request_count = Prometheus::Client::Counter.new(:site_requests_total, 'Total number of HTTP requests handled by Rails')
      $prometheus.register($request_count)

      $request_duration = Prometheus::Client::Summary.new(:request_duration, 'Duration of handling a call in Rails')
      $prometheus.register($request_duration)

      rails_up.set({app: "Shoppe"}, 1)
    end
  end
end
