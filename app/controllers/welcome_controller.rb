class WelcomeController < ApplicationController

  def index
    if session[:user_id]
      render 'feed/index'
    else
      render 'welcome/index'
    end
  end

end