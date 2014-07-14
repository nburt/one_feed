class FeedController < ApplicationController

  def index
    @providers = Providers.for(current_user)
    if @providers.none?
      @display_welcome = true
      render 'accounts/settings'
    end
  end

  def feed
    post = Post.find_by(user_id: current_user.id)
    if post && post.created_at > 10.minutes.ago
      cached_timeline = Cache::TimelineFormatter.new(post)
      cached_timeline.format
      @timeline = cached_timeline.timeline
      @unauthed_accounts = cached_timeline.unauthed_accounts
      @poster_recipient_profile_hash = cached_timeline.facebook_profile_pictures
      @load_more_url = feed_content_path(
        :twitter_pagination => cached_timeline.twitter_pagination_id,
        :facebook_pagination_id => cached_timeline.facebook_pagination_id,
        :instagram_max_id => cached_timeline.instagram_max_id
      )
    else
      feed = Feed.new(current_user)
      @timeline = feed.posts(params[:twitter_pagination], params[:facebook_pagination_id], params[:instagram_max_id])
      @unauthed_accounts = feed.unauthed_accounts
      @poster_recipient_profile_hash = feed.poster_recipient_profile_hash

      @load_more_url = feed_content_path(
        :twitter_pagination => feed.twitter_pagination_id,
        :facebook_pagination_id => feed.facebook_pagination_id,
        :instagram_max_id => feed.instagram_max_id
      )
    end

    fragment = render_to_string 'feed/feed', layout: false
    render json: { unauthed_accounts: @unauthed_accounts, fragment: fragment }
  end

end