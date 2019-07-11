Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/admin/users/:id/favorite', to: 'users#like'

  namespace :admin do
    resources :users
    get '/admin/users/:id/favorite', to: 'users#like'
  end

  root to: 'posts#top'
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments
  end
end
