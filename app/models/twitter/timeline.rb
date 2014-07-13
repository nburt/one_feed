module Twitter
  class Timeline

    attr_reader :authed,
                :last_post_id

    def initialize(user)
      @user = user
      @authed = true
    end

    def posts(max_id = nil)
      token = user_token
      client = configure_twitter(token)
      timeline = get_timeline(client, max_id)
      store_last_post_id(timeline)
      timeline
    end

    def get_tweet(tweet_id)
      token = user_token
      client = configure_twitter(token)
      client.status(tweet_id)
    end

    def create_tweet(tweet)
      token = user_token
      client = configure_twitter(token)
      client.update(tweet)
    end

    def favorite_tweet(tweet_id)
      token = user_token
      client = configure_twitter(token)
      client.favorite(tweet_id)
    end

    def retweet_tweet(tweet_id)
      token = user_token
      client = configure_twitter(token)
      client.retweet(tweet_id)
    end

    private

    def user_token
      @user.tokens.find_by(provider: 'twitter')
    end

    def configure_twitter(tokens)
      tokens.configure_twitter(tokens.access_token, tokens.access_token_secret)
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

    def store_last_post_id(timeline)
      if timeline.last.nil?
        @last_post_id = nil
      else
        @last_post_id = timeline.last.id
      end
    end

  end
end
