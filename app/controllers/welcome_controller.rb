class WelcomeController < ApplicationController

  def index
    if current_user
      render action: 'feed'
    else
      @User = User.new
      render action: 'index'
    end
  end

end