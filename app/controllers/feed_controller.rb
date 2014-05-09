class FeedController < ApplicationController

  def index

    provider = Provider.find_by(user_id: session[:user_id])

    client = provider.configure_twitter(provider.twitter_access_token, provider.twitter_access_token_secret)

    @timeline = client.home_timeline

    render 'feed/index'
  end
end