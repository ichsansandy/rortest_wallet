Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # User route
      resources :users, only: [] do
        collection do
          post 'update_email_password/:user_id', to: 'users#update_email_and_password'
          get 'get_balance/:user_id', to: 'users#get_balance'
        end
      end

      # Wallet routes
      post 'wallets/get_balance', to: 'wallets#get_balance'
      
      # Transaction routes
      resources :transactions, only: [] do
        collection do
          post :credit
          post :debit
          post :transfer
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
