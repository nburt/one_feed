class PostsController < ApplicationController

  def new

  end

  def create
    if params[:provider][:twitter]
      post = params[:post]
      twitter_timeline = Twitter::Timeline.new(current_user)
      twitter_timeline.create_tweet(post)
    end
    if params[:provider][:facebook]
      post = params[:post]
      token = current_user.tokens.find_by(provider: 'facebook')
      facebook_api = Facebook::Api.new(token.access_token, nil)
      facebook_api.create_post(post)
    end
    redirect_to feed_path
  end

end