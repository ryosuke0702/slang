class PostsController < ApplicationController
  skip_before_action :login_required, only: [:top]

  def index
    @user = User.find_by(id: session[:user_id])#マイページ
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(PER)

  end

  def show
    @post = Post.find(params[:id])
    @user = User.find_by(id: @post.user_id)
    @posts = Post.all
    @comment = Comment.new
    @comments = @post.comments
  end

  def new
    @post = current_user.posts.build
    @user = User.find_by(id: session[:user_id])#マイページ
  end

  def edit
    @user = User.find_by(id: session[:user_id])#マイページ
    @post = Post.find(params[:id])

    if current_user.admin?
      render :edit
    elsif @current_user.id != @post.user_id
      redirect_to posts_url, alert: "不正なアクセスです"
    end
  end

  def update
    post = Post.find(params[:id])
    post.update!(post_params)
    redirect_to posts_url, notice: "Updated「#{post.name}」"
  end

  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))

    if @post.save
       redirect_to @post, notice: "Posted「#{@post.name}」"
    else
      flash.now[:alert] = t'posts.flash.alert'
      render :new
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_url, notice: "Deleted「#{post.name}」"
  end

  def top
    @user = User.find_by(id: session[:user_id])#マイページ
  end

  private

  def post_params
    params.require(:post).permit(:name, :description, :category_id)
  end
end
