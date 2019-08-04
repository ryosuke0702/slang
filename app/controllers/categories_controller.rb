class CategoriesController < ApplicationController
  skip_before_action :login_required, only: [:show]

  def show
    @category = Category.find(params[:id])
    @posts = Post.where(category_id: params[:id]).order(created_at: :desc).page(params[:page]).per(PER)
    @user = User.find_by(id: session[:user_id])#マイページ
  end
end
