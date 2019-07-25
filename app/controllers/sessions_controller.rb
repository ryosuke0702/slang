class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
    #if not session[:user_id].nil?
    #  redirect_to root_path, alert: "不正なアクセスです"
    #end
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'login'
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
