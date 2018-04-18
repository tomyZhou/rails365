if ENV['USE_OFFICIAL_GEM_SOURCE']
  source 'https://rubygems.org'
else
  source 'https://gems.ruby-china.org'
  # source 'https://mirrors.tuna.tsinghua.edu.cn/rubygems/'
end

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '5.2.0'
gem 'bootsnap'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'pg'

gem 'jquery-rails'
gem 'jbuilder'
gem 'sdoc', group: :doc
gem 'bootstrap-sass'
gem 'slim-rails'

# markdown
gem 'redcarpet'
gem 'rouge', git: 'https://github.com/stanhu/rouge'

# configuration
gem 'config'

# file upload
gem 'carrierwave'
gem 'jquery-fileupload-rails'
gem 'carrierwave-aliyun'
gem 'mini_magick'

gem 'kaminari'
gem 'kaminari-i18n'
gem 'awesome_print'

# monitor
# gem 'rack-mini-profiler', require: false

# background
gem 'sidekiq'

# notification
gem 'exception-track'

# friendly url
gem 'friendly_id'
gem 'ruby-pinyin'
gem 'babosa'

gem 'rails-i18n'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.4'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'spring-commands-rspec'
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem "spring-commands-cucumber"
end

gem 'rubocop', require: false
gem 'codecov', require: false, group: :test

group :development do
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
  gem 'guard-cucumber'
  gem 'pry'
  gem 'capistrano', '~> 3.5.0'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
  gem 'capistrano3-puma'
  gem 'capistrano-faster-assets'
  gem 'capistrano-rails-console'
  gem "capistrano-db-tasks", require: false

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'sinatra', require: nil
gem 'pghero'

# user authentication
gem 'devise'
gem 'cancancan'
gem 'rails-timeago'
gem 'rucaptcha', '~> 2.1.0'
gem 'devise-async'
gem 'omniauth-github'

# data migrate
gem 'migration_data'

# theme
gem 'bootswatch-rails'

gem 'faraday'

# admin
gem 'rails_admin'

# redis cache
gem 'redis-namespace'
gem 'redis-rails'
gem 'hiredis'
gem 'identity_cache'
gem 'cityhash'

# websocket
gem 'tubesock'

# elasticsearch
gem 'searchkick', '~> 3'
# 提高性能
gem 'oj'
gem 'typhoeus'
gem "searchjoy"

gem 'puma'

# gem 'rack-attack'

gem 'auto-correct'
gem 'dalli'

gem 'letter_avatar'
gem 'chinese_pinyin'

gem 'rails-bootstrap-markdown'

gem 'social-share-button'
gem 'sweetalert-rails'

gem 'rails_autolink'
gem 'jquery-infinite-pages'
gem 'like_system'
gem 'google-analytics-rails', '1.1.1'

gem 'whenever', :require => false
gem 'by_star', git: "git://github.com/radar/by_star"
gem "select2-rails"
gem 'groupdate'
gem 'chartkick'

gem 'public_activity'

gem 'ransack'
