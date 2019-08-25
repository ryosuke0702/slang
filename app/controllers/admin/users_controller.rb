class Admin::UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def index
    @users = User.all.order(created_at: :desc)
    if not current_user.admin?
      redirect_to root_path, alert: "不正なアクセスです"
    end
  end

  def show
    @user = User.find_by(id: session[:user_id])#マイページ
    @users = User.find(params[:id])
    @posts = @users.posts.all.order(created_at: :desc).page(params[:page]).per(PER) #新しい順に表示、ページごとの取得数
  end

  def like
    @user = User.find(params[:id])
    @posts = @user.posts.all.order(created_at: :desc).page(params[:page]).per(PER)
    @likes = Like.where(user_id: @user.id)
  end

  def new
    @user = User.new
    if current_user.nil?
      render :new
    elsif not current_user.admin || current_user.id.nil?
      redirect_to root_path, alert: "不正なアクセスです"
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to admin_user_path(@user), notice: "「#{@user.name}」を登録しました"
    else
      render :new
    end
  end

  def facebook #facebookログイン
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_auth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Login with Facebook'
    end
  end

  def edit
    @user = User.find(params[:id])

    if current_user.admin?
      render :edit
    elsif @current_user.id !=  params[:id].to_i
      redirect_to posts_url, alert: "不正なアクセスです"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "Updated「#{@user.name}」"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    #NotificationMailer.destroy_mail(@user).deliver_now #メールで通知
    redirect_to root_path, notice: "Deleted「#{@user.name}」"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end
end
