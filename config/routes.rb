Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  scope '(:locale)', locale: /#{I18n.available_locales.map(&:to_s).join('|')}/ do


    #get '/auth/:provider/callback',    to: 'sessions#facebook_login',      as: :auth_callback
    #get '/auth/failure',               to: 'sessions#auth_failure',        as: :auth_failure
    #match "/auth/:provider/callback" => 'sessions#createByFacebook', via: 'get'

    get '/login', to: 'sessions#new'
    #post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    #get '/auth/:provider/callback', to: 'sessions#create'
    #get '/auth/failure', to: 'sessions#auth_failure'

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
