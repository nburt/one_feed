class FeedController < ApplicationController

  def index
    feed = Feed.new(current_user)
    posts_time = Benchmark.realtime do
      @timeline = feed.posts
    end
    Rails.logger.info(("-" * 10) + "POSTS TIME: #{posts_time}")
    @unauthed_accounts = feed.unauthed_accounts
    @poster_recipient_profile_hash = feed.poster_recipient_profile_hash
    @commenter_profile_hash = feed.commenter_profile_hash

    render 'welcome/feed'
  end

end