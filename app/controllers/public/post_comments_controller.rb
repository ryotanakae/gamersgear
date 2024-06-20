class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!, unless: :admin_signed_in?
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    if @comment.save
      redirect_to post_path(@post), notice: 'コメントを投稿しました'
    else
      @comments = @post.post_comments.includes(:user)
      flash.now[:alert] = @comment.errors.full_messages.join(", ")
      redirect_to post_path(@post), alert: 'コメントの投稿に失敗しました'
    end
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = PostComment.find(params[:id])
    # コメントしたユーザー、管理者、レビュー投稿者がコメントを削除できる記述
    if @comment.user == current_user || admin_signed_in? || @post.user == current_user
      @comment.destroy
      redirect_to request.referer, notice: 'コメントを削除しました'
    else
      redirect_to request.referer, alert: 'コメントの削除に失敗しました'
    end
  end
  
  private
  
  def post_comment_params
    params.require(:post_comment).permit(:body)
  end
  
end
