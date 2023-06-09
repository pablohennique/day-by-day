Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :entries
  resources :obstacles, only: %i[index show]
  patch 'obstacles/:id', to: 'obstacles#done', as: :done
  resources :recommendations, only: %i[show update]
end
