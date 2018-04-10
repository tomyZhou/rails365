require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'articles#index'

  # 评论
  concern :commentable do
    resources :comments, only: [:create]
  end

  # 喜欢
  concern :like do
    get :like, on: :member
  end

  resources :books, only: [:index]
  namespace :ahoy do
    resources :visits, only: [:index]
  end

  resources :activities, only: [:index, :destroy] do
    delete :destroy_multiple, on: :collection
  end

  resources :articles, concerns: [:commentable, :like]
  resources :orders, only: [:index, :new, :create]
  resources :movies, concerns: [:commentable, :like]
  get "/movies/all/:name", to: "movies#index", as: :all_movies
  get "/movies/q/:filter", to: "movies#index", as: :q_movies
  resources :softs, concerns: [:commentable, :like]
  resources :groups, only: [:index, :show]
  resources :playlists, only: [:index, :show]
  # resources :apps, only: [:index]
  resources :users, only: [:show, :index] do
    member do
      get :articles
      get :like_articles
      get :movie_history
    end
    collection do
      get :change_profile
      post :update_profile
    end
  end

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
  get 'find', to: 'home#find'
  get '/about-us', to: 'home#about_us'
  get '/vip', to: 'home#vip'
end
