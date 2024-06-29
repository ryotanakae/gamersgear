class Public::SearchesController < ApplicationController

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      # ユーザー検索
      @users = User.looks(params[:search], params[:word])
    else
      # 投稿検索
      @posts = Post.joins(:user, :category)
                   .where('posts.title LIKE ? OR posts.body LIKE ? OR users.name LIKE ? OR categories.name LIKE ?', "%#{@word}%", "%#{@word}%", "%#{@word}%", "%#{@word}%")
                   .page(params[:page])
                   .per(7)
                  # 検索結果のソート
      @posts = sort_posts(@posts)
    end
  end

  private

  # ソート機能
  def sort_posts(posts)
    case params[:sort]
    when 'newest'
      # 新着順
      posts = posts.order(created_at: :desc)
    when 'oldest'
      # 古い順
      posts = posts.order(created_at: :asc)
    when 'highest_rated'
      # 評価の高い順
      posts = posts.order(star: :desc)
    when 'most_liked'
      # いいねの多い順
      posts = posts.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC')
    when 'most_commented'
      # コメントの多い順
      posts = posts.left_joins(:post_comments).group(:id).order('COUNT(post_comments.id) DESC')
    else
      # デフォルトはソートなし
      posts
    end
    posts.page(params[:page]).per(7)
  end

end
