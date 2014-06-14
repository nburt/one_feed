class Posts

  attr_reader :unauthed_accounts

  def initialize(params, user)
    @params = params
    @user = user
    @unauthed_accounts = []
  end

  def twitter
    tweet = nil
    if @params[:twitter] == "true"
      post = @params[:post]
      twitter_timeline = Twitter::Timeline.new(@user)
      begin
        tweet = twitter_timeline.create_tweet(post)
      rescue Twitter::Error::Unauthorized
        @unauthed_accounts << "Twitter"
      end
    end
    tweet
  end

  def facebook
    facebook_post = nil
    facebook_profile_picture = nil
    full_facebook_post = nil
    if @params[:facebook] == "true"
      post = @params[:post]
      token = @user.tokens.find_by(provider: 'facebook')
      facebook_api = Facebook::Api.new(token.access_token, nil)
      begin
        post_id = facebook_api.create_post(post)
        facebook_api.get_post(post_id)
        facebook_post_response = facebook_api.facebook_post_response
        facebook_post = facebook_post_response.post
        facebook_profile_picture = facebook_post_response.poster_profile_picture
        full_facebook_post = facebook_post.merge(facebook_profile_picture)
      rescue Facebook::Unauthorized
        @unauthed_accounts << "Facebook"
      end
    end
    full_facebook_post
  end

end