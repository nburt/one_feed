class Feed

  include ApplicationHelper

  attr_reader :poster_recipient_profile_hash, :commenter_profile_hash, :unauthed_accounts, :twitter_pagination, :facebook_pagination_id, :instagram_max_id

  def initialize(current_user)
    @current_user = current_user
    @unauthed_accounts = []
  end

  def posts(twitter_pagination, facebook_pagination_id, instagram_max_id)
    twitter_timeline = []
    if current_user_has_provider?('twitter', @current_user)
      twitter_timeline_class = TwitterTimeline.new(@current_user)
      twitter_timeline = twitter_timeline_class.timeline(twitter_pagination)
      if twitter_timeline.last != nil
        @twitter_pagination = twitter_timeline.last.id
      else
        @twitter_pagination = nil
      end
      unless twitter_timeline_class.authed
        @unauthed_accounts << "twitter"
      end
    end

    instagram_timeline = []
    if current_user_has_provider?('instagram', @current_user)
      instagram_timeline_class = InstagramTimeline.new(@current_user)
      instagram_timeline = instagram_timeline_class.timeline(instagram_max_id)
      @instagram_max_id = instagram_timeline_class.pagination_max_id
      unless instagram_timeline_class.authed
        @unauthed_accounts << "instagram"
      end
    end

    facebook_timeline = []
    if current_user_has_provider?('facebook', @current_user)
      facebook_timeline_class = FacebookTimeline.new(@current_user)
      facebook_timeline = facebook_timeline_class.timeline(facebook_pagination_id)
      unless facebook_timeline_class.authed
        @unauthed_accounts << "facebook"
      end
      @poster_recipient_profile_hash = facebook_timeline_class.poster_recipient_profile_hash
      @commenter_profile_hash = facebook_timeline_class.commenter_profile_hash
      @facebook_pagination_id = facebook_timeline_class.next
    end

    timeline_concatenator = TimelineConcatenator.new
    timeline_concatenator.merge(twitter_timeline, instagram_timeline, facebook_timeline)
  end

end