class WelcomeController < ApplicationController

  def index
    if current_user
      redirect_to feed_path
    else
      @user = User.new
      render action: 'index'
    end
  end

end