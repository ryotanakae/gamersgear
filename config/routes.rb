Rails.application.routes.draw do
  namespace :admin do
    get 'categories/index'
    get 'categories/edit'
  end
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
  
  # 会員側ルーティング
  root to: 'public/homes#top'
  
  scope module: :public do
    get '/about', to: 'homes#about'
    get 'users/information/edit', to: 'users#edit'
    patch 'users/information', to: 'users#update'
    get 'users/:id/confirmation', to: 'users#confirm', as: 'confirm_user'
    patch 'users/:id/withdraw', to: 'users#withdraw', as: 'user_withdraw'
    
    resources :posts do
      resources :post_comments, only: [:create, :destroy], path: 'comments' # URLをpost_commentsからcommentsに変更する
      resources :likes, only: [:index, :create, :destroy]
    end
    
    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    
    resources :searches, only: [:index]
    
  end
  
  #管理者側ルーティング
  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :posts, only: [:index, :show, :destroy]
    resources :post_comments, only: [:index, :show, :destroy]
    resources :categories
    resources :searches, only: [:index]
  end

end
