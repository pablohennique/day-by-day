Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :entries
  resources :obstacles, only: %i[show]
  get 'obstacle/:user_id', to: 'obstacles#index', as: 'obstacles_path'

  patch 'obstacles/:id', to: 'obstacles#done', as: :done
  resources :recommendations, only: %i[show update]

  require "sidekiq"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
