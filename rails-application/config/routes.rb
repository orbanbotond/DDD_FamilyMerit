Rails.application.routes.draw do
  resources :transactions, only: :index

  resources :fullfillments, only: [:index, :create, :new, :show] do
    member do
      get :deliver
      get :do_not_deliver
    end
  end

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
