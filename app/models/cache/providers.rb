module Cache
  class Providers
    def self.fetch_and_save_timelines(user)
      tokens = user.tokens
      instagram_token = tokens.find_by(provider: 'instagram')
      facebook_token = tokens.find_by(provider: 'facebook')
      twitter_token = tokens.find_by(provider: 'twitter')

      instagram_timeline = fetch_instagram(instagram_token)
      facebook_timeline = fetch_facebook(facebook_token)
      twitter_timeline = fetch_twitter(twitter_token)

      post_hash = create_post_hash(instagram_timeline, facebook_timeline, twitter_timeline)

      Post.create!(post_hash: post_hash, user_id: user.id)
    end

    def self.clear_user_posts(user)
      Post.where(user_id: user.id).delete_all
    end

    private

    def self.create_post_hash(instagram_timeline, facebook_timeline, twitter_timeline)
      hash = {}
      if instagram_timeline == []
        hash
      else
        hash['instagram'] = {body: instagram_timeline.body, code: instagram_timeline.code}
      end

      if facebook_timeline == []
        hash
      else
        hash['facebook'] = {body: facebook_timeline.body, code: facebook_timeline.code, profile_pictures: facebook_timeline.profile_pictures}
      end

      if twitter_timeline == []
        hash
      elsif twitter_timeline.code == 400
        hash['twitter'] = {body: twitter_timeline.body, code: 400}
      else
        hash['twitter'] = {body: twitter_timeline.body, code: 200}
      end
      hash
    end

    def self.fetch_instagram(token)
      if token.nil?
        []
      else
        Cache::InstagramApi.get_timeline(token.access_token)
      end
    end

    def self.fetch_facebook(token)
      if token.nil?
        []
      else
        cache_facebook_api = Cache::FacebookApi.new(token.access_token)
        cache_facebook_api.get_timeline
        facebook = Struct.new(:body, :code, :profile_pictures)
        facebook.new(cache_facebook_api.timeline_response.body, cache_facebook_api.timeline_response.code, cache_facebook_api.profile_pictures)
      end
    end

    def self.fetch_twitter(token)
      if token.nil?
        []
      else
        begin
          timeline = Cache::TwitterApi.get_timeline(token)
          twitter = Struct.new(:body, :code)
          twitter.new(timeline, 200)
        rescue Twitter::Error::BadRequest, Twitter::Error::Unauthorized
          body = {
            "errors" => [
              {
                "message" => "Bad Authentication data",
                "code" => 215
              }
            ]
          }.to_json
          twitter = Struct.new(:body, :code)
          twitter.new(body, 400)
        end
      end
    end
  end
end