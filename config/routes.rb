Rails.application.routes.draw do
  root "flights#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
 # get "/flights/:id", to: "flights#show"
  # rails has routes method called resources, maps all conventional routes
  # for a collection of resources. get route above becomes unnecessary
  resources :flights
  # use command bin/rails routes to inspect all routes mapped
  # come back to rails guides section 6.2
  resources :transactions
end
