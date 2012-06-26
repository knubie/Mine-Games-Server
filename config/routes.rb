Server::Application.routes.draw do

  resources :users
  resources :matches
  resources :decks, only: [:index, :show, :update, :destroy]
  resources :sessions, only: [:create, :destroy]

  root :to => "home#index"

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout', to: 'sessions#destroy', via: :delete

  post '/end_turn/:id', to: 'matches#end_turn'

  match '/signup', to: 'users#new'
  post '/signin', to: 'sessions#create'
  match '/signout', to: 'sessions#destroy', via: :delete
  get '/friends', to: 'users#friends'
  get '/decks_by_user/:user_id', to: 'decks#index'

end
