class Feed

  def initialize(current_user)
    @current_user = current_user
  end

  def unauthed_accounts
    accounts = []
    token = @current_user.tokens.find_by(provider: 'instagram')
    if token != nil
      instagram_api = InstagramApi.new(token.access_token)
      timeline = instagram_api.get_timeline
      unless timeline.authed?
        accounts << 'Instagram'
      end
    end
  end

  def posts
    twitter_timeline = if current_user_has_provider?('twitter')
                         token = @current_user.tokens.find_by(provider: 'twitter')
                         client = token.configure_twitter(token.access_token, token.access_token_secret)
                         client.home_timeline
                       else
                         []
                       end

    instagram_timeline = if current_user_has_provider?('instagram')
                           token = @current_user.tokens.find_by(provider: 'instagram')
                           instagram_api = InstagramApi.new(token.access_token)
                           timeline = instagram_api.get_timeline
                           timeline.posts
                         else
                           []
                         end

    TimelineConcatenator.new.merge(twitter_timeline, instagram_timeline)
  end

  private

  def current_user_has_provider?(provider)
    @current_user.tokens.by_name(provider).any?
  end

end