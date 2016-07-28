Rails.application.routes.draw do
  resources :accounts, only: [:create]
  resources :connections, only: [:new, :create]
  resources :devices, only: [:index, :create, :destroy]
  resources :messages, only: [:show, :create]

  get "manifest" => "home#manifest", constraints: { format: :json }

  if Rails.env.production?
    get "/service-worker" => "service_worker#index", constraints: { format: :js }
  end

  root to: "home#index"
end
