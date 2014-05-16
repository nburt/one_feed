class TimelineConcatenator

  def merge(twitter_data, instagram_data)
    new_timeline = []

    twitter_data.each do |post|
      twitter_data = create_twitter_hash(post)
      new_timeline << twitter_data if twitter_data.present?
    end

    instagram_data.each do |post|
      instagram_data = create_instagram_hash(post)
      new_timeline << instagram_data if instagram_data.present?
    end

    new_timeline.sort_by {|x| x["created_time"]}.reverse
  end

  private

  def create_twitter_hash(post)
    twitter_hash = {}
    twitter_hash["provider"] = "twitter"
    twitter_hash["profile_picture"] = post["user"]["profile_image_url_https"]
    twitter_hash["user_name"] = post["user"]["name"]
    twitter_hash["user_url"] = post["user"]["url"]
    twitter_hash["screen_name"] = post["user"]["screen_name"]
    twitter_hash["created_time"] = Time.parse(post["created_at"].to_s)
    twitter_hash["tweet_text"] = post["text"]
    twitter_hash["retweet_count"] = post["retweet_count"]
    twitter_hash["favorite_count"] = post["favorite_count"]
    twitter_hash["link_to_tweet"] = "https://twitter.com/#{post["user"]["screen_name"]}/status/#{post["id"]}"
    twitter_hash
  end

  def create_instagram_hash(post)
    instagram_hash = {}
    instagram_hash["provider"] = "instagram"
    instagram_hash["profile_picture"] = post["user"]["profile_picture"]
    instagram_hash["username"] = post["user"]["username"]
    instagram_hash["user_url"] = "http://www.instagram.com/#{post["user"]["username"]}"
    instagram_hash["created_time"] = "#{Time.at(post["created_time"].to_i)}"
    instagram_hash["low_resolution_image_url"] = post["images"]["low_resolution"]["url"]
    if post["caption"] != nil
      instagram_hash["caption_text"] = post["caption"]["text"]
    end
    instagram_hash["link_to_post"] = post["link"]
    instagram_hash["comments_count"] = post["comments"]["count"]
    instagram_hash["comments"] = post["comments"]["data"]
    instagram_hash["likes_count"] = post["likes"]["count"]
    instagram_hash
  end

end