class FeedController < ApplicationController

  def index

    user = User.find(session[:user_id])

    client = user.configure_twitter(user.access_token, user.access_token_secret)

    @timeline = client.home_timeline

    render 'feed/index'
  end
end