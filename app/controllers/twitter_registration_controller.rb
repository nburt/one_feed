class TwitterRegistrationController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find(session[:user_id])
    Provider.update_or_create_with_omniauth(user.id, auth)
    redirect_to '/'
  end

  def failure
    redirect_to '/', flash: {:auth_failure => "Authentication failed."}
  end

end