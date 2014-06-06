module Twitter
  class Timeline

    attr_reader :authed,
                :last_post_id

    def initialize(user)
      @user = user
      @authed = true
    end

    def posts(max_id = nil)
      tokens = user_tokens
      client = tokens.configure_twitter(tokens.access_token, tokens.access_token_secret)
      timeline = get_timeline(client, max_id)
      store_last_post_id(timeline)
      timeline
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

    def store_last_post_id(timeline)
      if last = timeline.last
        @last_post_id = last.id
      else
        @last_post_id = nil
      end
    end

  end
end
