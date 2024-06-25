class Public::HomesController < ApplicationController

  def top
    @user = current_user
    @posts = Post.all.page(params[:page]).per(7)
    @categories = Category.all
    @posts = sort_posts(@posts)
    
  end

  private
  
  # ソート機能のロジック
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
