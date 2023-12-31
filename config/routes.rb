Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, except: [:show, :update] 
  get '/users/:id/detail', to: 'users#detail', as: 'user_detail'
  get '/users/home', to: 'users#home', as: 'user_home'
  post '/users/give_reward', to: 'users#give_reward'
  patch '/users/claim_reward', to: 'users#claim_reward'
  root 'maps#index'

  resources :maps
  post '/maps/create_simple', to: 'maps#create_simple', as: 'create_simple_map'
  get '/maps/:id/map_to_json', to: 'maps#map_to_json'

  resources :items
end
