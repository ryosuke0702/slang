Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    resources :users
    get '/admin/users/:id/favorite', to: 'users#like'
  end

  root to: 'posts#top'
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments

  end
  get '/categories/:id', to:'categories#show'
end
