class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @categories = Category.all
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "カテゴリを登録しました"
    else
      redirect_to admin_categories_path, alert: "カテゴリの作成に失敗しました"
    end
  end

  def show
    @category = Category.find(params[:id])
    @posts = @category.posts
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "カテゴリを更新しました"
    else
      redirect_to edit_admin_category_path, alert: "カテゴリの更新に失敗しました"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path, notice: "カテゴリを削除しました"
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end
end
