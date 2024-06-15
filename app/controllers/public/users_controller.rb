class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user .update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールが更新されました'
    else
      render :edit
    end
  end

  def confirm
    @user = User.find(params[:id])
  end

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_active: false)
    # is_activeカラムをfalseに変更する
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_active, :image)
  end

end
