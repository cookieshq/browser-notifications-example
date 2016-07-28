Rails.application.routes.draw do
  resources :accounts, only: [:create]
  resources :connections, only: [:new, :create]
  resources :devices, only: [:create]
  resources :messages, only: [:create]

  get "manifest" => "home#manifest", constraints: { format: :json }

  root to: "home#index"
end
