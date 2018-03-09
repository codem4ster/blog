require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'interactions')
    config.autoload_paths << Rails.root.join('app', 'validators')
    config.autoload_paths << Rails.root.join('app', 'inputs')
    config.autoload_paths << Rails.root.join('app', 'events')
    locale_path = Rails.root.join('config', 'locales', '**', '*.{rb,yml}')
    config.i18n.load_path += Dir[locale_path.to_s]
    config.i18n.available_locales = %i[tr]
    config.i18n.default_locale = :tr
    config.i18n.load_path += Dir[locale_path.to_s]
    config.active_job.queue_adapter = :sidekiq

    servers = [
      {
        host: '127.0.0.1',
        port: 6379,
        db: 6,
        # password: '*******',
        namespace: 'session'
      }
    ]
    options = {
      servers: servers,
      expire_after: 30.minutes,
      key: '_open_data_session'
    }
    config.session_store :redis_store, options

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
