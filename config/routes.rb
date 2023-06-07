Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # this route if for OPEN API testing purposes only
  post "/chat_test", to: "entries#chat_test", as: :chat_test
  resources :entries
  resources :obstacles, only: [:index, :show]

end
