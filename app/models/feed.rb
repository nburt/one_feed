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
      twitter_timeline = get_twitter_timeline
    end

    instagram_timeline = []
    if current_user_has_provider?('instagram', @current_user)
      instagram_timeline = get_instagram_timeline
    end

    facebook_timeline = []
    if current_user_has_provider?('facebook', @current_user)
      facebook_timeline = get_facebook_timeline
    end

    timeline_concatenator = TimelineConcatenator.new
    timeline_concatenator.merge(twitter_timeline, instagram_timeline, facebook_timeline)
  end

  private

  def get_facebook_timeline
    token = @current_user.tokens.find_by(provider: 'facebook')
    facebook_api = FacebookApi.new(token.access_token)
    facebook_api.timeline
    unless facebook_api.success?
      @unauthed_accounts << "facebook"
    end
    @poster_recipient_profile_hash = facebook_api.poster_recipient_profile_hash
    @commenter_profile_hash = facebook_api.commenter_profile_hash
    facebook_api.posts
  end

  def get_twitter_timeline
    twitter_timeline = []
    token = @current_user.tokens.find_by(provider: 'twitter')
    client = token.configure_twitter(token.access_token, token.access_token_secret)
    begin
      twitter_timeline = client.home_timeline
    rescue Twitter::Error::Forbidden
      @unauthed_accounts << "twitter"
    rescue Twitter::Error::Unauthorized
      @unauthed_accounts << "twitter"
    end
    twitter_timeline
  end

  def get_instagram_timeline
    token = @current_user.tokens.find_by(provider: 'instagram')
    instagram_api = InstagramApi.new(token.access_token)
    timeline = instagram_api.get_timeline
    unless timeline.success?
      @unauthed_accounts << "instagram"
    end
    timeline.posts
  end

end