Rails.application.routes.draw do
  resources :accounts, only: [:create]
  resources :connections, only: [:new, :create]

  root to: "home#index"
end
