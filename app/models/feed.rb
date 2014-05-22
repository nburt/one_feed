class Feed

  include ApplicationHelper

  attr_reader :to_from_profile_hash, :comments_profile_hash

  def initialize(current_user)
    @current_user = current_user
  end

  def unauthed_accounts
    @current_user.tokens.invalid
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
    @to_from_profile_hash = facebook_api.to_from_profile_hash
    @comments_profile_hash = facebook_api.comments_profile_hash
    facebook_api.posts
  end

  def get_twitter_timeline
    twitter_timeline = []
    token = @current_user.tokens.find_by(provider: 'twitter')
    client = token.configure_twitter(token.access_token, token.access_token_secret)
    begin
      twitter_timeline = client.home_timeline
    rescue Twitter::Error::Forbidden
      report_twitter_error
    rescue Twitter::Error::Unauthorized
      report_twitter_error
    end
    twitter_timeline
  end

  def get_instagram_timeline
    token = @current_user.tokens.find_by(provider: 'instagram')
    instagram_api = InstagramApi.new(token.access_token)
    timeline = instagram_api.get_timeline
    timeline.posts
  end

  def report_twitter_error
    @twitter_fail = true
  end

end