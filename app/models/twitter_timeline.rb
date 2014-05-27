class TwitterTimeline

  attr_reader :authed

  def initialize(user)
    @user = user
    @authed = true
  end

  def timeline
    twitter_timeline = []
    token = @user.tokens.find_by(provider: 'twitter')
    client = token.configure_twitter(token.access_token, token.access_token_secret)
    begin
      twitter_timeline = client.home_timeline
    rescue Twitter::Error::Forbidden
      @authed = false
    rescue Twitter::Error::Unauthorized
      @authed = false
    end
    twitter_timeline
  end

end
