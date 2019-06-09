class PostsController < ApplicationController
  skip_before_action :login_required, only: [:top]
  PER = 12

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(PER)
  end

  def show
    @post = Post.find(params[:id])
    #@user = User.find(params[:id])
    @user = User.find_by(id: @post.user_id)
    #@posts = current_user.posts.build
    @posts = Post.all
  end

  def new
    #@post = Post.new
    @post = current_user.posts.build
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update!(post_params)
    redirect_to posts_url, notice: "「#{post.name}」を更新しました"
  end

  def create
    @post =  Post.new(post_params.merge(user_id: current_user.id))
    #@post = current_user.posts.build(post_params)

    if @post.save
       redirect_to @post, notice: "「#{@post.name}」を登録しました"
    else
      render :new
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_url, notice: "「#{post.name}」を削除しました"
  end

  def top
  end

  private

  def post_params
    params.require(:post).permit(:name, :description)
  end
end
