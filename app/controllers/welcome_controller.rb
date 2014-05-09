class WelcomeController < ApplicationController

  def index
    if current_user
      render action: 'feed'
    else
      render action: 'index'
    end
  end

end