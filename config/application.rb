require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'tilt/coffee'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails365
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Beijing'
    config.i18n.default_locale = :'zh-CN'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'form_builders')
    config.generators.assets = false
    config.generators.helper = false

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
    config.exceptions_app = self.routes
    config.cache_store = :redis_store, { host: Settings.redis_host, port: 6379, namespace: 'rails365', driver: :hiredis }
    config.identity_cache_store = :redis_store, { host: Settings.redis_host, port: 6379, namespace: 'rails365_cache', driver: :hiredis }
    # config.middleware.delete 'Rack::ConditionalGet'
    # config.middleware.delete 'Rack::ETag'
    # config.middleware.delete 'Rack::Runtime'
    # config.middleware.delete 'Rack::Sendfile'
    # config.middleware.use Rack::Attack

    # config.to_prepare do
    #   Devise::SessionsController.layout "devise"
    #   Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application" : "devise" }
    #   Devise::ConfirmationsController.layout "devise"
    #   Devise::UnlocksController.layout "devise"
    #   Devise::PasswordsController.layout "devise"
    # end
  end
end
