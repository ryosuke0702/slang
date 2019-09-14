class SessionsController < ApplicationController
  skip_before_action :login_required

  def new #remove(不正アクセス防止)
    remove
  end

  def new_facebook
    remove
  end

  def new_mail
    remove
  end

  def sns
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_auth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Successfully login'
    end
  end

  def create #既存ログイン
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Login'
    else
      flash.now[:alert] = t'sessions.flash.alert'
      render  :new
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
