class TwitterRegistrationController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find(session[:user_id])
    User.update_with_omniauth(user.id, auth)
    redirect_to '/feed'
  end

  def failure
    redirect_to '/feed', flash: {:auth_failure => "Authentication failed."}
  end

end