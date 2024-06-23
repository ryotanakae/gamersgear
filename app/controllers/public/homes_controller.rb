class Public::HomesController < ApplicationController

  def top
    @user = current_user
    @posts = Post.all.page(params[:page]).per(7)
    @categories = Category.all
  end

  def about
  end
end
