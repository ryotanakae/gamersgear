class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_root_path(@user), notice: "会員情報が更新されました"
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end

  def withdraw
    @user.update(is_active: false)
    redirect_to admin_root_path
  end

  def user_params
    params.require(:user).permit(:name, :email, :is_active)
  end
end
