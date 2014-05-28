class FeedController < ApplicationController

  def index

  end

  def feed
    feed = Feed.new(current_user)
    @timeline = feed.posts(params[:twitter_pagination], params[:facebook_pagination_id], params[:instagram_max_id])
    @unauthed_accounts = feed.unauthed_accounts
    @poster_recipient_profile_hash = feed.poster_recipient_profile_hash
    @commenter_profile_hash = feed.commenter_profile_hash

    @load_more_url = feed_content_path(
      :twitter_pagination => feed.twitter_pagination,
      :facebook_pagination_id => feed.facebook_pagination_id,
      :instagram_max_id => feed.instagram_max_id
    )

    render 'feed/feed', layout: false
  end

end