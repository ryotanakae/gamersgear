class Public::HomesController < ApplicationController
  def top
    @user = current_user
    @posts = Post.all.page(params[:page]).per(7)
    @categories = Category.all
    @posts = sort_posts(@posts)
  end


  private
    # ソート機能
    def sort_posts(posts)
      case params[:sort]
      when "newest"
        # 新着順
        posts = posts.order(created_at: :desc)
      when "oldest"
        # 古い順
        posts = posts.order(created_at: :asc)
      when "highest_rated"
        # 評価の高い順
        posts = posts.order(star: :desc)
      when "most_liked"
        # いいねの多い順
        posts = posts.left_joins(:likes).group(:id).order("COUNT(likes.id) DESC")
      when "most_commented"
        # コメントの多い順
        posts = posts.left_joins(:post_comments).group(:id).order("COUNT(post_comments.id) DESC")
      else
        # デフォルトはソートなし
        posts
      end
      posts.page(params[:page]).per(7)
    end
end
