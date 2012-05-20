Server::Application.routes.draw do

  resources :users
  # resources :matches
  resources :sessions, only: [:new, :create, :destroy]

  root :to => "home#index"

  match '/auth/:provider/callback' => 'sessions#create'

  match '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/lobby', to: 'users#lobby'
  get '/friends', to: 'users#friends'
  post '/matches/:id/actions', to: 'matches#actions'
  get 'access_token/:token', to: 'users#show'
  get '/matches/all', to: 'matches#all'

end
