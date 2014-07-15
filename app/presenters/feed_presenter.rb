class FeedPresenter

  def initialize(user, params)
    @user = user
    @twitter_pagination = params[:twitter_pagination]
    @facebook_pagination_id = params[:facebook_pagination_id]
    @instagram_max_id = params[:instagram_max_id]
  end

  def timeline
    @timeline ||= feed.timeline
  end

  delegate :unauthed_accounts, to: :feed
  delegate :facebook_profile_pictures, to: :feed

  def load_more_url_options
    {
      :twitter_pagination => feed.twitter_pagination_id,
      :facebook_pagination_id => feed.facebook_pagination_id,
      :instagram_max_id => feed.instagram_max_id
    }
  end

  private

  def cached_post
    @cached_post ||= Post.find_by(user_id: @user.id)
  end

  def feed
    @feed ||= if can_use_cached_post?
                Cache::TimelineFormatter.new(cached_post)
              else
                Feed.new(@user, @twitter_pagination, @facebook_pagination_id, @instagram_max_id)
              end
  end

  def can_use_cached_post?
    cached_post &&
      cached_post.created_at > 10.minutes.ago &&
      @twitter_pagination.blank? &&
      @facebook_pagination_id.blank? &&
      @instagram_max_id.blank?
  end
end