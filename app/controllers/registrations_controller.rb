class RegistrationsController < ApplicationController

  def create
    user = User.create!(user_params)
    session[:user_id] = user.id
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end