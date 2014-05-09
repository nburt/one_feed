class TwitterRegistrationController < ApplicationController
  require 'twitter'

  rescue_from Twitter::Error::Forbidden, with: :redirect_to_twitter_auth

  def create
    auth = request.env["omniauth.auth"]
    user = User.find(session[:user_id])
    Provider.update_or_create_with_omniauth(user.id, auth)
    redirect_to '/feed'
  end

  def failure
    redirect_to '/feed', flash: {:auth_failure => "Authentication failed."}
  end

end