class TwitterRegistrationController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find(session[:user_id])
    Token.update_or_create_with_twitter_omniauth(user.id, auth)
    redirect_to '/'
  end

  def failure
    redirect_to settings_account_path(session[:user_id]), flash: {:auth_failure => "Authentication failed."}
  end

end