class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]

    case @range
    when "User"
      @users = User.looks(params[:search], params[:word])
    when "Post"
      @posts = Post.looks(params[:search], params[:word]).page(params[:page]).per(7)
      @posts = sort_posts(@posts)
    when "PostComment"
      @post_comments = PostComment.joins(:post, :user).where('post_comments.body LIKE ? OR posts.title LIKE ? OR users.name LIKE ?', "%#{@word}%", "%#{@word}%", "%#{@word}%")
    end
    
  end
  
  private

  def sort_posts(posts)
    case params[:sort]
    when 'newest'
      posts = posts.order(created_at: :desc)
    when 'oldest'
      posts = posts.order(created_at: :asc)
    when 'highest_rated'
      posts = posts.order(star: :desc)
    when 'most_liked'
      posts = posts.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC')
    when 'most_commented'
      posts = posts.left_joins(:post_comments).group(:id).order('COUNT(post_comments.id) DESC')
    else
      posts
    end
    posts.page(params[:page]).per(7)
  end

end
