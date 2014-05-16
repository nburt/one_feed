class FeedController < ApplicationController

  def index
    feed = Feed.new(current_user)
    @unauthed_accounts = feed.unauthed_accounts # => twitter / instagram
    @timeline = feed.posts # timeline concatenator

    render 'welcome/feed'
  end

end