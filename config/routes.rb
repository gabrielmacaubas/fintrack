Rails.application.routes.draw do
  get "dashboard/index"
  resources :categories
  resources :expenses
  resources :incomes
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  # Custom route for resetting finances
  delete "users/reset_finances", to: "users/registrations#reset_finances", as: :reset_finances
  
  root "dashboard#index"

  # Settings routes
  get "settings", to: "settings#index"
  patch "settings", to: "settings#update"
  delete "settings/reset_finances", to: "settings#reset_finances"
  delete "settings/destroy_account", to: "settings#destroy_account"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
