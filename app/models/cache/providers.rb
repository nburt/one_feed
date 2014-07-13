module Cache
  class Providers
    def self.fetch_and_save_timelines(user)
      tokens = user.tokens
      instagram_token = tokens.find_by(provider: 'instagram')
      facebook_token = tokens.find_by(provider: 'facebook')
      twitter_token = tokens.find_by(provider: 'twitter')

      instagram_timeline = fetch_and_save_instagram(instagram_token)
      facebook_timeline = fetch_and_save_facebook(facebook_token)
      twitter_timeline = fetch_and_save_twitter(twitter_token)

      post_array = create_post_array(instagram_timeline, facebook_timeline, twitter_timeline)

      Post.create!(post_array: post_array, user_id: user.id)
    end

    def self.clear_user_posts(user)
      Post.where(user_id: user.id).delete_all
    end

    private

    def self.create_post_array(instagram_timeline, facebook_timeline, twitter_timeline)
      array = []
      if instagram_timeline == []
        array << {provider: 'instagram', body: instagram_timeline, status: 401}
      else
        array << {provider: 'instagram', body: instagram_timeline.body, status: instagram_timeline.code}
      end

      if facebook_timeline == []
        array << {provider: 'facebook', body: facebook_timeline, status: 190}
      else
        array << {provider: 'facebook', body: facebook_timeline.body, status: facebook_timeline.code}
      end

      if twitter_timeline == []
        array << {provider: 'twitter', body: twitter_timeline, status: 401}
      elsif twitter_timeline.code == 400
        array << {provider: 'twitter', body: twitter_timeline.body, status: 400}
      else
        array << {provider: 'twitter', body: twitter_timeline, status: 200}
      end
      array
    end

    def self.fetch_and_save_instagram(token)
      if token.nil?
        []
      else
        Cache::InstagramApi.get_timeline(token.access_token)
      end
    end

    def self.fetch_and_save_facebook(token)
      if token.nil?
        []
      else
        Cache::FacebookApi.get_timeline(token.access_token)
      end
    end

    def self.fetch_and_save_twitter(token)
      if token.nil?
        []
      else
        begin
          Cache::TwitterApi.get_timeline(token)
        rescue Twitter::Error::BadRequest, Twitter::Error::Unauthorized
          body = {
            "errors" => [
              {
                "message" => "Bad Authentication data",
                "code" => 215
              }
            ]
          }.to_json
          Struct.new("Twitter", :body, :code)
          Struct::Twitter.new(body, 400)
        end
      end
    end
  end
end