class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.all.page(params[:page]).per(7)
    @posts = sort_posts(@posts)

  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    render 'public/posts/show'
  end

  def edit
    @post = Post.find(params[:id])
    render template: 'public/posts/edit'
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: '編集に成功しました'
    else
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      render template: 'public/posts/edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: '投稿を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :star, :category_id, :image)
  end

  def sort_posts(posts)
    case params[:sort]
    when 'newest'
      posts.order(created_at: :desc)
    when 'oldest'
      posts.order(created_at: :asc)
    when 'highest_rated'
      posts.order(star: :desc)
    when 'most_liked'
      posts.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC')
    when 'most_commented'
      posts.left_joins(:post_comments).group(:id).order('COUNT(post_comments.id) DESC')
    else
      posts
    end
  end

end
