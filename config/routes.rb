Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

#facebookログイン
  get '/auth/:provider/callback',    to: 'users#create',       as: :auth_callback
  get '/auth/failure',               to: 'users#auth_failure', as: :auth_failure

  namespace :admin do
    resources :users
    get '/admin/users/:id/favorite', to: 'users#like'
  end

  root to: 'posts#top'
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments

  end
  resources :categories
  #get '/categories/:id', to:'categories#show'
end
