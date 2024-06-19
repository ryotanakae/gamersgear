class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]

    case @range
    when "User"
      @users = User.looks(params[:search], params[:word])
    when "Post"
      @posts = Post.looks(params[:search], params[:word])
    when "PostComment"
      @post_comments = PostComment.joins(:post, :user).where('post_comments.body LIKE ? OR posts.title LIKE ? OR users.name LIKE ?', "%#{@word}%", "%#{@word}%", "%#{@word}%")
    end
  end

end
