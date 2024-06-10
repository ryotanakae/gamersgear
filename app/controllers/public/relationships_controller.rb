class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to request.referer
  end

  # フォロー一覧表示
  def followings
    @user = User.find(params[:user_id])
    @users = @user.following
  end

  # フォロワー一覧表示
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end

end
