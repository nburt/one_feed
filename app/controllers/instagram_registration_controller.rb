class InstagramRegistrationController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find(session[:user_id])
    Provider.update_or_create_with_instagram_omniauth(user.id, auth)
    redirect_to '/'
  end

end