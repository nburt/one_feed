class TwitterTimeline

  attr_reader :authed

  def initialize(user)
    @user = user
    @authed = true
  end

  def posts(max_id = nil)
    twitter_timeline = []
    token = @user.tokens.find_by(provider: 'twitter')
    client = token.configure_twitter(token.access_token, token.access_token_secret)
    begin
      if max_id.nil?
        twitter_timeline = client.home_timeline(:count => 5)
      else
        twitter_timeline = client.home_timeline(:max_id => max_id, :count => 6)
        twitter_timeline.delete_at(0)
      end
    rescue Twitter::Error::Forbidden
      @authed = false
    rescue Twitter::Error::Unauthorized
      @authed = false
    end
    twitter_timeline
  end

end
