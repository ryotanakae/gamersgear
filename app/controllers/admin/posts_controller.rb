class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @post = Post.find(params[:id])
    @user = @post.user
    render 'public/posts/show'
  end

  def edit
    @post = Post.find(params[:id])
    render 'public/posts/edit'
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: '編集に成功しました'
    else
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      render 'public/posts/edit'
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
  
  end
end
