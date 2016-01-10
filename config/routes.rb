require 'sidekiq/web'
Rails.application.routes.draw do
  root to: 'home#index'

  resources :articles, only: [:show, :index]
  resources :groups, only: [:show, :index]
  resources :tags, only: [:index]

  namespace :admin do
    root to: "articles#index"
    resources :articles, only: [:edit, :destroy, :index, :new, :update, :create] do
      get :unpublished, on: :collection
    end
    resources :groups, only: [:edit, :destroy, :index, :new, :update, :create]
    resources :sites, except: [:show]
    resources :exception_logs, only: [:show, :destroy, :index] do
      delete :destroy_multiple, on: :collection
    end
    resources :sidekiq_exceptions, only: [:show, :destroy, :index] do
      delete :destroy_multiple, on: :collection
    end
  end

  %w(404 422 500).each do |code|
    get code, to: "errors#show", code: code
  end

  patch '/photos', to: "photos#create"
  get 'tags/:tag_id', to: 'articles#index', as: :tag

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["USERNAME"] && password == ENV['PASSWORD']
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'
  mount PgHero::Engine, at: "pghero"
end
