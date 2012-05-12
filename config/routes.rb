Server::Application.routes.draw do

  resources :users
  resources :matches
  resources :sessions, only: [:new, :create, :destroy]

  root :to => "home#index"

  match '/auth/:provider/callback' => 'sessions#create'

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

end
