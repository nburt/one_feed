class Feed

  include ApplicationHelper

  attr_reader :poster_recipient_profile_hash,
              :commenter_profile_hash,
              :unauthed_accounts,
              :twitter_pagination_id,
              :facebook_pagination_id,
              :instagram_max_id

  def initialize(current_user)
    @current_user = current_user
    @unauthed_accounts = []
  end

  def posts(twitter_pagination_id, facebook_pagination_id, instagram_max_id)

    TimelineConcatenator.new.merge(twitter_posts(twitter_pagination_id),
                                   instagram_posts(instagram_max_id),
                                   facebook_posts(facebook_pagination_id))
  end

  private

  def twitter_posts(twitter_pagination_id)
    if current_user_has_provider?('twitter', @current_user)
      twitter_timeline = TwitterTimeline.new(@current_user)
      twitter_posts = twitter_timeline.posts(twitter_pagination_id)
      get_twitter_pagination_id(twitter_posts)
      auth_twitter(twitter_timeline)
      twitter_posts
    else
      []
    end
  end

  def auth_twitter(twitter_timeline)
    unless twitter_timeline.authed
      @unauthed_accounts << "twitter"
    end
  end

  def get_twitter_pagination_id(twitter_posts)
    if twitter_posts.last != nil
      @twitter_pagination_id = twitter_posts.last.id
    else
      @twitter_pagination_id = nil
    end
  end

  def instagram_posts(instagram_max_id)
    if current_user_has_provider?('instagram', @current_user)
      instagram_timeline = InstagramTimeline.new(@current_user)
      instagram_posts = instagram_timeline.posts(instagram_max_id)
      @instagram_max_id = instagram_timeline.pagination_max_id
      auth_instagram(instagram_timeline)
      instagram_posts
    else
      []
    end
  end

  def auth_instagram(instagram_posts)
    unless instagram_posts.authed
      @unauthed_accounts << "instagram"
    end
  end

  def facebook_posts(facebook_pagination_id)
    if current_user_has_provider?('facebook', @current_user)
      facebook_timeline = FacebookTimeline.new(@current_user)
      facebook_posts = facebook_timeline.posts(facebook_pagination_id)
      auth_facebook(facebook_timeline)
      @poster_recipient_profile_hash = facebook_timeline.poster_recipient_profile_hash
      @commenter_profile_hash = facebook_timeline.commenter_profile_hash
      @facebook_pagination_id = facebook_timeline.pagination_id
      facebook_posts
    else
      []
    end
  end

  def auth_facebook(facebook_timeline)
    unless facebook_timeline.authed
      @unauthed_accounts << "facebook"
    end
  end

end