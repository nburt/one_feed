class PostsController < ApplicationController

  def create
    unauthed_accounts = []

    tweet = nil
    if params[:twitter] == "true"
      post = params[:post]
      twitter_timeline = Twitter::Timeline.new(current_user)
      begin
        tweet = twitter_timeline.create_tweet(post)
      rescue Twitter::Error::Unauthorized
        unauthed_accounts << "Twitter"
      end
    end

    facebook_post = nil
    facebook_profile_picture = nil
    full_facebook_post = nil
    if params[:facebook] == "true"
      post = params[:post]
      token = current_user.tokens.find_by(provider: 'facebook')
      facebook_api = Facebook::Api.new(token.access_token, nil)
      post_id = facebook_api.create_post(post)
      begin
        facebook_api.get_post(post_id)
        facebook_post_response = facebook_api.facebook_post_response
        facebook_post = facebook_post_response.post
        facebook_profile_picture = facebook_post_response.poster_profile_picture
        full_facebook_post = facebook_post.merge(facebook_profile_picture)
      rescue Facebook::Unauthorized
        unauthed_accounts << "Facebook"
      end
    end

    render json: {tweet: tweet, facebook_post: full_facebook_post, unauthed_accounts: unauthed_accounts}
  end

end