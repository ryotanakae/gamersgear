class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show], unless: :admin_signed_in?
  before_action :set_categories

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: "投稿に成功しました"
    else
      @user = current_user
      @books = Post.all
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      render :new
    end
  end

  def index
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @posts = @category.posts.page(params[:page]).per(7)
    else
      @posts = Post.all.page(params[:page]).per(7)
    end
    # ソート機能のロジック desc=降順 asc=昇順
    @posts = sort_posts(@posts)

  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def edit
    @user = current_user
    @post = Post.find(params[:id])
  end

  def update
    @user = current_user
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: '編集に成功しました'
    else
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @user = current_user
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path, notice: '投稿を削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :star, :category_id, :image,)
  end

  def set_categories
    @categories = Category.all
  end
  
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
