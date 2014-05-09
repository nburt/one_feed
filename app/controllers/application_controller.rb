class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  rescue_from Twitter::Error::Forbidden, with: :redirect_to_twitter_auth

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def redirect_to_twitter_auth
    redirect_to '/auth/twitter'
  end
end
