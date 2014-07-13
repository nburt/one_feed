module Cache
  class InstagramApi
    def self.get_timeline(access_token)
      Typhoeus.get("https://api.instagram.com/v1/users/self/feed?access_token=#{access_token}&count=5")
    end
  end
end