class Feed

  include ApplicationHelper

  attr_reader :poster_recipient_profile_hash, :commenter_profile_hash, :unauthed_accounts

  def initialize(current_user)
    @current_user = current_user
    @unauthed_accounts = []
  end

  def posts
    twitter_timeline = []
    if current_user_has_provider?('twitter', @current_user)
      twitter_timeline_class = TwitterTimeline.new(@current_user)
      twitter_timeline = twitter_timeline_class.timeline
      unless twitter_timeline_class.authed
        @unauthed_accounts << "twitter"
      end
    end

    instagram_timeline = []
    if current_user_has_provider?('instagram', @current_user)
      instagram_timeline_class = InstagramTimeline.new(@current_user)
      instagram_timeline = instagram_timeline_class.timeline
      unless instagram_timeline_class.authed
        @unauthed_accounts << "instagram"
      end
    end

    facebook_timeline = []
    if current_user_has_provider?('facebook', @current_user)
      facebook_timeline_class = FacebookTimeline.new(@current_user)
      facebook_timeline = facebook_timeline_class.timeline
      unless facebook_timeline_class.authed
        @unauthed_accounts << "facebook"
      end
      @poster_recipient_profile_hash = facebook_timeline_class.poster_recipient_profile_hash
      @commenter_profile_hash = facebook_timeline_class.commenter_profile_hash
    end

    timeline_concatenator = TimelineConcatenator.new
    timeline_concatenator.merge(twitter_timeline, instagram_timeline, facebook_timeline)
  end

end