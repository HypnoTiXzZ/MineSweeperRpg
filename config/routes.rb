Rails.application.routes.draw do
  root 'maps#index'

  resources :maps
  get '/maps/:id', to: 'maps#show'
end
