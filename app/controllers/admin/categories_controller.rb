class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @categories = Category.all
    @category = Category.new
  end
  
  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: 'カテゴリを登録しました'
    else
      @categories = Category.all
      render :index
    end
  end
  
  def show
    @category = Category.find(params[:id])
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'カテゴリを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path, notice: 'カテゴリを削除しました'
  end
  
  private
  
  def category_params
    params.require(:category).permit(:name)
  end
end
