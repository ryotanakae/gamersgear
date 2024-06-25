class Public::SearchesController < ApplicationController
  
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @posts = Post.looks(params[:search], params[:word]).page(params[:page]).per(7)
      @posts = sort_posts(@posts)
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
