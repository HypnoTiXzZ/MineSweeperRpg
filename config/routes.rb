Rails.application.routes.draw do
  root 'maps#index'

  resources :maps
  get '/maps/:id', to: 'maps#show'
  get '/maps/:id/map_to_json', to: 'maps#map_to_json'
end
