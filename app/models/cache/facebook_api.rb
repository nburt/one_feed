module Cache
  class FacebookApi
    def self.get_timeline(access_token)
      Typhoeus.get("https://graph.facebook.com/v2.0/me/home?limit=5&access_token=#{access_token}")
    end
  end
end