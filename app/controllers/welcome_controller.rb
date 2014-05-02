class WelcomeController < ApplicationController
  require 'twitter'

  rescue_from Twitter::Error::Forbidden, with: :redirect_to_twitter_auth

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

  private

  def redirect_to_twitter_auth
    redirect_to '/auth/twitter'
  end

end