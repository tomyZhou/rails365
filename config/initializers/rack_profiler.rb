require 'rack-mini-profiler'

if !Rails.env.test?
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.storage_options = { host: '127.0.0.1', port: '6379', db: 2 }
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
  Rack::MiniProfiler.config.disable_env_dump = true
  Rack::MiniProfiler.config.skip_paths = ['/ws']
end
