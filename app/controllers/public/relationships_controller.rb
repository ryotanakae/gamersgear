class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!, unless: :admin_signed_in?

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
  end

  # フォロー一覧表示
  def following
    @user = User.find(params[:user_id])
    @users = @user.following
  end

  # フォロワー一覧表示
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end

end
