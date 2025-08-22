Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    post 'upload/:folder_name', to: 'upload#create'
    post 'upload', to: 'upload#create'  # Default route without folder
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
