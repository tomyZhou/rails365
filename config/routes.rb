require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'home#index'

  # 评论
  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :books, only: [:index]

  resources :articles, concerns: [:commentable]
  resources :movies, concerns: [:commentable]
  resources :groups, only: [:index, :show]
  resources :playlists, only: [:index, :show]
  resources :apps, only: [:index]
  resources :users, only: [:show]

  %w(404 422 500).each do |code|
    get code, to: 'errors#show', code: code
  end

  patch '/photos', to: 'photos#create'

  authenticate :user, lambda { |u| u.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticate :user, lambda { |u| u.super_admin? } do
    mount PgHero::Engine, at: 'pghero'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get '/ws', to: 'websocket#ws'
end
