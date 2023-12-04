Rails.application.routes.draw do
  devise_for :users
  resources :users
  get '/users/:id/detail', to: 'users#detail', as: 'user_detail'
  root 'maps#index'

  resources :maps
  post '/maps/create_simple', to: 'maps#create_simple', as: 'create_simple_map'
  get '/maps/:id', to: 'maps#show'
  get '/maps/:id/map_to_json', to: 'maps#map_to_json'
end
