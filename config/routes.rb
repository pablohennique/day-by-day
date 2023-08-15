Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :entries
  resources :obstacles, only: %i[index show]
  get '/get_obstacle_status', to: 'obstacles#get_obstacle_status'
  get '/render_completed_obstacle_card', to: 'obstacles#render_completed_obstacle_card'

  patch 'obstacles/:id', to: 'obstacles#done', as: :done
  resources :recommendations, only: %i[show update]

  get '/tactics', to: 'pages#tactics', as: :tactics

  require "sidekiq"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
