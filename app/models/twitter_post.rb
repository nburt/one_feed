class TwitterPost

  def initialize(tweet)
    @tweet = tweet
  end

  def to_hash
    twitter_hash = {}
    twitter_hash["provider"] = "twitter"
    twitter_hash["profile_picture"] = @tweet["user"]["profile_image_url_https"]
    twitter_hash["user_name"] = @tweet["user"]["name"]
    twitter_hash["user_url"] = "https://twitter.com/#{@tweet["user"]["screen_name"]}"
    twitter_hash["screen_name"] = @tweet["user"]["screen_name"]
    twitter_hash["created_time"] = parse_time(@tweet["created_at"].to_s)
    twitter_hash["tweet_text"] = @tweet["text"]
    twitter_hash["retweet_count"] = @tweet["retweet_count"].to_i
    twitter_hash["favorite_count"] = @tweet["favorite_count"].to_i
    twitter_hash["link_to_tweet"] = "https://twitter.com/#{@tweet["user"]["screen_name"]}/status/#{@tweet["id"]}"
    if @tweet["media"].present?
      twitter_hash["tweet_image"] = @tweet["media"][0]["media_url"]
    end
    twitter_hash
  end

  private

  def parse_time(created_time)
    "#{Time.parse(created_time)}"
  end

end