class TwitterValidator

  def initialize(token)
    @token = token
  end

  def valid?
    client = @token.configure_twitter(@token.access_token, @token.access_token_secret)
    begin
      !!client.home_timeline
    rescue Twitter::Error::Forbidden
      false
    rescue Twitter::Error::Unauthorized
      false
    end
  end

end