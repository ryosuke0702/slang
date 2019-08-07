class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

#  def create　#(従来のログイン処理)
#    user = User.find_by(email: session_params[:email])
#    if user&.authenticate(session_params[:password])
#      session[:user_id] = user.id
#      redirect_to root_path, notice: 'login'
#    else
#      flash.now[:alert] = t'sessions.flash.alert'
#      render  :new
#    end
#  end

#  def facebook_login
#    @user = User.from_omniauth(request.env["omniauth.auth"])
#      result = @user.save(context: :facebook_login)
#      if result
#        log_in @user
#        redirect_to @user
#      else
#        redirect_to auth_failure_path
#      end
#  end

  #認証に失敗した際の処理
#  def auth_failure
#    @user = User.new
#    render '任意のアクション'
#  end

  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_auth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_back_or user
    else #既存パタン
      user = User.find_by(email: session_params[:email])
      if user&.authenticate(session_params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: 'login'
      else
        flash.now[:alert] = t'sessions.flash.alert'
        render  :new
      end
    end
  end





  def destroy
    reset_session
    redirect_to root_path, notice: 'Logout'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
