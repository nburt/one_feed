class WelcomeController < ApplicationController
  require 'twitter'

  rescue_from Twitter::Error::Forbidden, with: :redirect_to_twitter_auth

  def index
    render 'welcome/index'
  end

  private

  def redirect_to_twitter_auth
    redirect_to '/auth/twitter'
  end

end