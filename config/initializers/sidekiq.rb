Sidekiq.configure_server do |config|
  config.redis = { :namespace => ENV['sidekiq_namespace'] }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => ENV['sidekiq_namespace'] }
end

Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new do |ex,ctx_hash|
    Admin::SidekiqException.create!(ex: ex, ctx_hash: ctx_hash)
  end
end
