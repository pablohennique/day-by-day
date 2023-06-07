Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :entries
  resources :obstacles, only: [:index, :show]

end
