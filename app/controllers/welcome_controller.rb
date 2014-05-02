class WelcomeController < ApplicationController
  require 'twitter'

  def index
    if current_user

      user = User.find(session[:user_id])

      client = user.configure_twitter(user.access_token, user.access_token_secret)

      @timeline = client.home_timeline

      render 'feed/index'
    else
      render 'welcome/index'
    end
  end

end