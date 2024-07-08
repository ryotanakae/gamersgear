Rails.application.routes.draw do
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  # ゲストログイン用
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  # 会員側ルーティング
  root to: 'public/homes#top'

  scope module: :public do
    get '/about', to: 'homes#about'
    get 'users/information/edit', to: 'users#edit'
    patch 'users/information', to: 'users#update'
    get 'users/:id/confirmation', to: 'users#confirm', as: 'confirm_user'
    patch 'users/:id/withdraw', to: 'users#withdraw', as: 'user_withdraw'
    get '/privacy_policy', to: 'homes#privacy_policy'
    get '/terms', to: 'homes#terms'

    resources :posts do
      resources :post_comments, only: [:create, :destroy], path: 'comments' # URLをpost_commentsからcommentsに変更する
      resource :like, only: [:index, :create, :destroy]
    end

    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get "following" => "relationships#following", as: "following"
      get "followers" => "relationships#followers", as: "followers"
      member do
        get :likes
      end
    end
    
    get 'search', to: 'searches#search'
    resources :searches, only: [:index]
    resources :categories, only: [:show, :index]
    
    resources :notifications, only: [:update, :destroy] do
      collection do
        delete :destroy_all
      end
    end

  end

  #管理者側ルーティング
  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        patch :withdaw # memberをつけると:idが付与される
      end
    end

    resources :posts, only: [:index, :show, :edit, :update, :destroy]
    resources :post_comments, only: [:index, :show, :destroy]
    resources :categories
    get 'search', to: 'searches#search'
    resources :searches, only: [:index]
  end

end
