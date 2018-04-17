# require 'rack-mini-profiler'
#
# if Rails.env.development?
#   Rack::MiniProfilerRails.initialize!(Rails.application)
#   Rack::MiniProfiler.config.storage_options = { host: Settings.redis_host, port: '6379', db: 2 }
#   Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
#   Rack::MiniProfiler.config.disable_env_dump = true
#   Rack::MiniProfiler.config.skip_paths = ['/ws']
# end
