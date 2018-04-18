# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'rails365'
set :repo_url, 'ssh://git@gitlab.rails365.net:10022/hfpp2012/rails365.git'
set :branch, 'master'
set :deploy_to, "/home/deploy/#{fetch(:application)}"
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/settings.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'pids', 'tmp/sockets', 'public/system')

# set :rbenv_type, :user # or :system, depends on your rbenv setup
# set :rbenv_ruby, '2.5.1'

# in case you want to set ruby version from the file:
# set :rbenv_ruby, File.read('.ruby-version').strip
#
# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# set :rbenv_map_bins, %w( rake gem bundle ruby rails sidekiq sidekiqctl )
# set :rbenv_roles, :all # default value

set :bundle_flags, ''

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :restart do
  end
end

namespace :logs do
  desc "tail rails logs" 
  task :tail_rails do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end
