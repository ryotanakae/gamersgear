class Public::SearchesController < ApplicationController
  
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @posts = Post.looks(params[:search], params[:word]).page(params[:page]).per(7)
    end
  end
  
end
