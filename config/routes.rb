Rails.application.routes.draw do
  resources :accounts, only: [:create]
  resources :connections, only: [:new, :create]

  get "manifest" => "home#manifest", constraints: { format: :json }

  root to: "home#index"
end
