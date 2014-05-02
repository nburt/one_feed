class WelcomeController < ApplicationController

  def index
    @failure = session[:auth_failure]
    if session[:user_id]
      render 'feed/index'
    else
      render 'welcome/index'
    end
  end

end