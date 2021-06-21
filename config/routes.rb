Rails.application.routes.draw do
  root "flight#index"
  get 'flight/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'flight/show'
  get "/flights/:id", to: "flight#show"
  # rails has routes method called resources, maps all conventional routes
  # for a collection of resources. get route above becomes unnecessary
  resources :flight #- not working bc my model is named flights and controller is named home
  # use command bin/rails routes to inspect all routes mapped
  # come back to rails guides section 6.2 
  get "/transactions", to: "transactions#index"
end
