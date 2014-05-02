class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.update_or_create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def failure
    redirect_to root_url, flash: {:auth_failure => "Authentication failed."}
  end
end