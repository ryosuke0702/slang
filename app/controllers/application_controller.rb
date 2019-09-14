class ApplicationController < ActionController::Base
  helper_method :remove
  helper_method :current_user
  before_action :login_required
  before_action :get_category
  PER = 12
  include SessionsHelper

  protect_from_forgery with: :exception
  before_action :set_locale

  def get_category
    @categories = Category.all
  end

  def set_locale
    I18n.locale = locale
  end

  def locale
    @locale ||= params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    options.merge(locale: locale)
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_facebook_path ,alert: "You need to login before continuing" unless current_user
  end

  def remove
    if current_user
      redirect_to root_path, alert: "不正なアクセスです"
    end
  end
end
