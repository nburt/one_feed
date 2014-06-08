class WelcomeController < ApplicationController

  def index
    if logged_in?
      redirect_to feed_path
    else
      @user = User.new
      render action: 'index'
    end
  end

  def privacy_policy
    @user = User.new
  end

end