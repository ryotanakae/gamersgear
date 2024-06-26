class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]

    case @range
    when "User"
      @users = User.looks(params[:search], params[:word])
    when "Post"
      @posts = Post.joins(:user, :category)
                   .where('posts.title LIKE ? OR posts.body LIKE ? OR users.name LIKE ? OR categories.name LIKE ?', "%#{@word}%", "%#{@word}%", "%#{@word}%", "%#{@word}%")
                   .page(params[:page])
                   .per(7)
      @posts = sort_posts(@posts)
    when "PostComment"
      @post_comments = PostComment.joins(:post, :user).where('post_comments.body LIKE ? OR posts.title LIKE ? OR users.name LIKE ?', "%#{@word}%", "%#{@word}%", "%#{@word}%")
    end
    
  end
  
  private

  def sort_posts(posts)
    case params[:sort]
    when 'newest'
      posts.order('posts.created_at DESC')
    when 'oldest'
      posts.order('posts.created_at ASC')
    when 'highest_rated'
      posts.order('posts.star DESC')
    when 'most_liked'
      posts.left_joins(:likes).group('posts.id').order('COUNT(likes.id) DESC')
    when 'most_commented'
      posts.left_joins(:post_comments).group('posts.id').order('COUNT(post_comments.id) DESC')
    else
      posts
    end
  end

end
