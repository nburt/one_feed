class Feed

  def initialize(current_user)
    @current_user = current_user
  end

  def unauthed_accounts
    @current_user.tokens.invalid
  end

  def posts
    twitter_timeline = []
    if current_user_has_provider?('twitter')
      twitter_timeline = get_twitter_timeline
    end

    instagram_timeline = []
    if current_user_has_provider?('instagram')
      instagram_timeline = get_instagram_timeline
    end

    timeline_concatenator = TimelineConcatenator.new
    timeline_concatenator.merge(twitter_timeline, instagram_timeline)
  end

  private

  def get_twitter_timeline
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

  def current_user_has_provider?(provider)
    @current_user.tokens.by_name(provider).any?
  end

  def report_twitter_error
    @twitter_fail = true
  end

end