class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required
  before_action :get_category
  PER = 9
  include SessionsHelper

  def get_category
    @categories = Category.all
  end


  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_path unless current_user
  end
end
