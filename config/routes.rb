Rails.application.routes.draw do
  # Root route
  root "sessions#new"

  # Authentication routes
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Admin routes
  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :distributors do
      resources :skus, only: [ :new, :create, :edit, :update, :destroy ]
    end
    resources :products do
      resources :skus, only: [ :new, :create, :edit, :update, :destroy ]
    end
    resources :users
  end

# Distributor routes
namespace :distributors do
  get "dashboard", to: "dashboard#index"
  resources :orders do
    member do
      get :review
    end
  end
end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
