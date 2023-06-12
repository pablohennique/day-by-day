Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :entries
  resources :obstacles, only: %i[index show]
  patch 'obstacles/:id', to: 'obstacles#done', as: :done
  resources :recommendations, only: %i[show update]

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
