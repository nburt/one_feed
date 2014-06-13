class SharesController < ApplicationController

  def twitter
    tweet_id = params[:tweet_id]
    twitter_timeline = Twitter::Timeline.new(current_user)
    twitter_timeline.retweet_tweet(tweet_id)
    tweet = twitter_timeline.get_tweet(tweet_id)
    render json: tweet
  end

end