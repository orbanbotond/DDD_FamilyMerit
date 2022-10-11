Rails.application.routes.draw do
  resources :activities
  resources :users

  resources :time_consumptions, only: [:new, :create]
  resources :time_gain, only: [:new, :create]

  resources :merits, only: [:index, :new, :create] do
    collection do
      get :balances
    end
    resources :merit_accounts, only: [:index, :new] do
      member do
        post :consume_time
        post :gain_time
      end
    end
  end

  mount RailsEventStore::Browser => "/res"
end
