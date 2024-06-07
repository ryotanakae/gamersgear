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
  
  # 会員側ルーティング
  root to: 'public/homes#top'
  
  scope module: :public do
    get '/about', to: 'homes#about'
    get 'mypage', to: 'users#mypage'
    get 'users/information/edit', to: 'users#edit'
    patch 'users/information', to: 'users#update'
    get 'users/unsubscribe', to: 'users#confirm'
    patch 'users/withdraw', to: 'users#withdraw'
    
    resources :posts do
      resources :post_comments, only: [:create, :destroy], path: 'comments' # URLをpost_commentsからcommentsに変更する
      resources :likes, only: [:index, :create, :destroy]
    end
    
    resources :relationships, only: [:index, :create, :destroy]
    resources :searches, only: [:index]
  end
  
  #管理者側ルーティング
  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :posts, only: [:index, :show, :destroy]
    resources :post_comments, only: [:index, :show, :destroy]
    resources :genres
    resources :searches, only: [:index]
  end

end
