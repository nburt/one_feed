class RegistrationsController < ApplicationController

  def create
    user = User.create!(:email => params[:user][:email], :password => params[:user][:password])
    session[:user_id] = user.id
    redirect_to root_url
  end

end