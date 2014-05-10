class WelcomeController < ApplicationController

  def index
    if current_user
      render action: 'feed'
    else
      @user = User.new
      render action: 'index'
    end
  end

end