require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails365
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.time_zone = 'Beijing'
    config.i18n.default_locale = :'zh-CN'

    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('app', 'form_builders')
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
    config.cache_store = :redis_cache_store, { host: Settings.redis_host, port: 6379, namespace: 'rails365', driver: :hiredis }
    config.identity_cache_store = :redis_cache_store, { host: Settings.redis_host, port: 6379, namespace: 'rails365_cache', driver: :hiredis }
  end
end
