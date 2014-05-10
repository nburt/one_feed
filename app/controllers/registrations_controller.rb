class RegistrationsController < ApplicationController

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url
    else
      render 'welcome/index'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end