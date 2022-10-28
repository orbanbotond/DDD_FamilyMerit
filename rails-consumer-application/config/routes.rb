Rails.application.routes.draw do
  resources :transactions, only: :index
  mount RailsEventStore::Browser => "/res"
end
