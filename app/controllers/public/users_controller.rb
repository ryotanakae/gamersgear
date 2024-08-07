class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :likes], unless: :admin_signed_in?
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(7)
    @posts = sort_posts(@posts)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user .update(user_params)
      redirect_to user_path(@user), notice: "プロフィールが更新されました"
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end

  def confirm
    @user = User.find(params[:id])
  end

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_active: false)
    # is_activeカラムをfalseに変更する
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to new_user_registration_path
  end

  def likes
    @user = User.find(params[:id])
    @liked_posts = @user.liked_posts
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :is_active, :image, :introduction)
    end

    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.email == "guest@example.com"
        redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      end
    end

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
