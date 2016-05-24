app_path = File.expand_path( File.join(File.dirname(__FILE__), '..'))
# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 1, 6

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix://#{app_path}/tmp/sockets/pumactl.sock"

# Logging
stdout_redirect "#{app_path}/log/puma.log", "#{app_path}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{app_path}/pids/puma.pid"
state_path "#{app_path}/tmp/sockets/puma.state"
daemonize true
preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end
