class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]

    case @range
    when "User"
      # ユーザー検索
      @users = User.looks(params[:search], params[:word])
    when "Post"
      # 投稿検索
      @posts = Post.joins(:user, :category)
                   .where('posts.title LIKE ? OR posts.body LIKE ? OR users.name LIKE ? OR categories.name LIKE ?', "%#{@word}%", "%#{@word}%", "%#{@word}%", "%#{@word}%")
                   .page(params[:page])
                   .per(7)
                  # 検索結果のソート
      @posts = sort_posts(@posts)
    when "PostComment"
      # コメント検索
      @post_comments = PostComment.joins(:post, :user).where('post_comments.body LIKE ? OR posts.title LIKE ? OR users.name LIKE ?', "%#{@word}%", "%#{@word}%", "%#{@word}%")
    end
    
  end
  
  private

  # 検索機能
  def sort_posts(posts)
    case params[:sort]
    when 'newest'
      # 新着順
      posts.order('posts.created_at DESC')
    when 'oldest'
      # 古い順
      posts.order('posts.created_at ASC')
    when 'highest_rated'
      # 評価の高い順
      posts.order('posts.star DESC')
    when 'most_liked'
      # いいねの多い順
      posts.left_joins(:likes).group('posts.id').order('COUNT(likes.id) DESC')
    when 'most_commented'
      # コメントの多い順
      posts.left_joins(:post_comments).group('posts.id').order('COUNT(post_comments.id) DESC')
    else
      # デフォルトはソートなし
      posts
    end
  end

end
