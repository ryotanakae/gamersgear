class Public::HomesController < ApplicationController

  def top
    @user = current_user
    @posts = Post.all
    @categories = Category.all
  end

  def about
  end
end
