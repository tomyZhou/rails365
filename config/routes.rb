require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  root to: 'home#index'

  resources :articles
  resources :groups
  resources :users, only: [:show]

  namespace :admin do
    root to: "articles#index"
    resources :sites, except: [:show]
    resources :site_infos, only: [:index, :update, :edit]
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

  authenticate :user, lambda { |u| u.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticate :user, lambda { |u| u.super_admin? } do
    mount PgHero::Engine, at: "pghero"
  end

  mount RuCaptcha::Engine => "/rucaptcha"

  mount Homeland::Engine, at: "/homeland"

  mount StatusPage::Engine, at: '/web'
end
