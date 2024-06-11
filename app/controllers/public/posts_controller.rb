class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  
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
    @posts = Post.all
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
    if @post.upadate(post_params)
      redirect_to post_path(@post.id), notice: '編集に成功しました'
    else
      render :edit
    end
  end
  
  def destroy
    @user = current_user
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: '投稿を削除しました'
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :body, :star, :category_id, :image)
  end
  
end
