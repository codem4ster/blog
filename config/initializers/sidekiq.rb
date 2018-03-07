require 'sidekiq-scheduler/web'

Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://127.0.0.1:6379/3',
    password: '1u2i3e4a'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://127.0.0.1:6379/3',
    password: '1u2i3e4a'
  }
end