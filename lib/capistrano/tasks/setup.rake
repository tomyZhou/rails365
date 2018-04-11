namespace :logs do
  desc "tail rails logs" 
  task :tail_rails do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end

namespace :task do
  desc 'Execute the specific rake task'
  task :invoke, :command do |task, args|
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, args[:command]
        end
      end
    end
  end
end

namespace :setup do
  desc "Create the database."
  task :create_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:create"
        end
      end
    end
  end

  desc "baidu article"
  task :baidu_article do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "baidu_article:puts"
        end
      end
    end
  end

  desc 'Execute the specific rake task'
  task :invoke, :command do |task, args|
    on roles(:app) do
      execute :rake, args[:command]
    end
  end

  # 调用 bundle exec cap setup:all_movies_list| awk '{$1="";print}'
  desc "print all movies based on its playlist"
  task :all_movies_list do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "print:all_movies_list"
        end
      end
    end
  end

  # 调用 bundle exec cap "setup:playlist_movies_list[诱人的 react 视频教程-基础篇]" | awk '{$1="";print}'
  desc "print playlist's movies"
  task :playlist_movies_list, :command do |task, args|
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "'print:playlist_movies_list[#{args[:command]}]'"
        end
      end
    end
  end
end

namespace :load do
  task :defaults do
    load 'capistrano/defaults.rb'
  end
end

stages.each do |stage|
  Rake::Task.define_task(stage) do
    set(:stage, stage.to_sym)

    invoke 'load:defaults'
    load deploy_config_path
    load stage_config_path.join("#{stage}.rb")
    load "capistrano/#{fetch(:scm)}.rb"
    I18n.locale = fetch(:locale, :en)
    configure_backend
  end
end
Rake::Task[:production].invoke
