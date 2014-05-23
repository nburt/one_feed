class FeedController < ApplicationController

  def index

  end

  def feed
    feed = Feed.new(current_user)
    @timeline = feed.posts
    @unauthed_accounts = feed.unauthed_accounts
    @poster_recipient_profile_hash = feed.poster_recipient_profile_hash
    @commenter_profile_hash = feed.commenter_profile_hash

    render 'welcome/feed', layout: false
  end

end