class RegistrationsController < ApplicationController

  def new
    @User = User.new
  end

  def create
    user = User.create!(:email => params[:user][:email], :password => params[:user][:password])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def login
    @User = User.new
  end

  def logged_in
    user = User.find_by :email => params[:user][:email]
    if user.present? && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to root_url
    else
      session[:user_id] = nil
      redirect_to login_path, flash: {:login_failure => "Invalid email or password"}
    end
  end

end