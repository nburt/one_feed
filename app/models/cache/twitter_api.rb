module Cache
  class TwitterApi
    def self.get_timeline(token)
      client = token.configure_twitter(token.access_token, token.access_token_secret)
      client.home_timeline(:count => 5)
    end
  end
end