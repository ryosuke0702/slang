class Admin::UsersController < ApplicationController
  #issue2のコメントです
  #コメント
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
    @posts = @users.posts.all.order(created_at: :desc).page(params[:page]).per(PER)
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
    if env['omniauth.auth'].present?
        # Facebookログイン
        @user  = User.from_omniauth(env['omniauth.auth'])
        result = @user.save(context: :facebook_login)
        fb       = "Facebook"
    else
        # 通常サインアップ
        @user = User.new(user_params)
        if @user.save
          log_in @user
          redirect_to admin_user_path(@user), notice: "「#{@user.name}」を登録しました"
        else
          render :new
        end
    end
    if result
        sign_in @user
        flash[:success] = "#{fb}ログインしました。"
        redirect_to @user
    else
        if fb.present?
            redirect_to auth_failure_path
        else
            render 'new'
        end
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
      redirect_to admin_user_path(@user), notice: "「#{@user.name}」を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, notice: "「#{@user.name}」を削除しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end
end
