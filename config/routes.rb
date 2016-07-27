Rails.application.routes.draw do
  resources :accounts, only: [:create]

  root to: "home#index"
end
