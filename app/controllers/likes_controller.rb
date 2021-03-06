class LikesController < ApplicationController

  def twitter
    tweet_id = params[:tweet_id]
    twitter_timeline = Twitter::Timeline.new(current_user)
    twitter_timeline.favorite_tweet(tweet_id)
    tweet = twitter_timeline.get_tweet(tweet_id)
    render json: tweet
  end

  def instagram
    media_id = params[:media_id]
    tokens = current_user.tokens.find_by(provider: 'instagram')
    instagram_api = Instagram::Api.new(tokens.access_token, nil)
    instagram_api.like_post(media_id)
    post = instagram_api.get_post(media_id).parse
    render json: post
  end

  def facebook
    post_id = params[:post_id]
    tokens = current_user.tokens.find_by(provider: 'facebook')
    facebook_api = Facebook::Api.new(tokens.access_token, nil)
    facebook_api.like_post(post_id)
    facebook_api.get_post(post_id)
    post = facebook_api.facebook_post_response.post
    render json: post
  end

end