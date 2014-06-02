class TwitterTimeline

  attr_reader :authed

  def initialize(user)
    @user = user
    @authed = true
  end

  def posts(max_id = nil)
    twitter_timeline = []
    tokens = user_tokens
    client = tokens.configure_twitter(tokens.access_token, tokens.access_token_secret)
    begin
      twitter_timeline = get_timeline(client, max_id)
    rescue Twitter::Error::Forbidden
      @authed = false
    rescue Twitter::Error::Unauthorized
      @authed = false
    end
    twitter_timeline
  end

  private

  def user_tokens
    @user.tokens.find_by(provider: 'twitter')
  end

  def get_timeline(client, max_id)
    if max_id.nil?
      client.home_timeline(:count => 5)
    else
      twitter_timeline = client.home_timeline(:max_id => max_id, :count => 26)
      twitter_timeline.delete_at(0)
      twitter_timeline
    end
  end

end
