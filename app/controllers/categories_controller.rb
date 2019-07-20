class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @posts = Post.where(category_id: params[:id]).order(created_at: :desc).page(params[:page]).per(PER)
  end
end
