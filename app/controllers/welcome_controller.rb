class WelcomeController < ApplicationController

  def index
    render 'welcome/index'
  end

  private

  def redirect_to_twitter_auth
    redirect_to '/auth/twitter'
  end

end