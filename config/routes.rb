Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.map(&:to_s).join('|')}/ do


  namespace :admin do
    resources :users
    get '/admin/users/:id/favorite', to: 'users#like'
  end

    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    namespace :admin do
      resources :users
      get '/admin/users/:id/favorite', to: 'users#like'
    end

    root to: 'posts#index'
    resources :posts do
      resources :likes, only: [:create, :destroy]
      resources :comments
    end
    resources :categories
  end
end
