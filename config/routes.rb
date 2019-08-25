Rails.application.routes.draw do

  scope '(:locale)', locale: /#{I18n.available_locales.map(&:to_s).join('|')}/ do

    get 'auth/:provider/callback', to: 'sessions#facebook' #facebookログイン

    get '/login', to: 'sessions#new'  #メールログインフォーム
    post '/login', to: 'sessions#create'
    get '/login/facebook', to: 'sessions#new_facebook' #二択画面
    get '/signup', to: 'sessions#new_mail' #二択画面
    delete '/logout', to: 'sessions#destroy' #ログアウト

    namespace :admin do
      get '/admin/users/:id/favorite', to: 'users#like'
      resources :users #do
        #member do
        #get 'facebook' #'/auth/:provider/callback', to: 'users#
        #end
    #  end
    end


    root to: 'posts#index'
    resources :posts do
      resources :likes, only: [:create, :destroy]
      resources :comments
    end
    resources :categories
  end
end
