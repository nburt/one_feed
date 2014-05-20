class TimelineConcatenator

  def merge(twitter_timeline, instagram_timeline, facebook_timeline)
    new_timeline = []

    twitter_timeline.each do |tweet|
      tweet_hash = create_twitter_hash(tweet)
      new_timeline << tweet_hash if tweet_hash.present?
    end

    instagram_timeline.each do |instagram_post|
      instagram_post_hash = create_instagram_hash(instagram_post)
      new_timeline << instagram_post_hash if instagram_post_hash.present?
    end

    facebook_timeline.each do |facebook_post|
      facebook_post_hash = create_facebook_hash(facebook_post)
      new_timeline << facebook_post_hash if facebook_post_hash.present?
    end

    new_timeline.sort_by { |x| x["created_time"] }.reverse
  end

  private

  def create_facebook_hash(facebook_post)
    from_hash = {}
    from_hash["profile_picture"] = FacebookApi.user_profile_picture(facebook_post["from"]["id"])
    from_hash["name"] = facebook_post["from"]["name"]
    from_hash["link_to_profile"] = "https://www.facebook.com/app_scoped_user_id/#{facebook_post["from"]["id"]}"

    image_hash = {}
    image_hash["original_sized_image"] = facebook_original_size_image(facebook_post["picture"]) if facebook_post["picture"] != nil
    image_hash["caption_text"] = facebook_post["description"] if facebook_post["description"] != nil

    facebook_hash = {}
    facebook_hash["provider"] = "facebook"
    facebook_hash["created_time"] = "#{Time.parse(facebook_post["created_time"])}"
    facebook_hash["from"] = from_hash
    facebook_hash["image"] = image_hash if image_hash != {}
    facebook_hash["message"] = facebook_post["message"] if facebook_post["message"] != nil
    facebook_hash["story"] = facebook_post["story"] if facebook_post["story"] != nil
    if facebook_post["likes"] != nil
      facebook_hash["likes_count"] = facebook_post["likes"]["data"].count
    else
      facebook_hash["likes_count"] = 0
    end
    if facebook_post["comments"] != nil
      facebook_hash["comments_count"] = facebook_post["comments"].count
    else
      facebook_hash["comments_count"] = 0
    end
    facebook_hash["comments"] = facebook_comments(facebook_post["comments"]["data"]) if facebook_post["comments"] != nil
    facebook_hash["story_tags"] = facebook_story_tags(facebook_post["story_tags"]) if facebook_post["story_tags"] != nil
    facebook_hash["application_name"] = facebook_post["application"]["name"] if facebook_post["application"] != nil
    facebook_hash["link_to_post"] = facebook_post["link"] if facebook_post["link"] != nil
    facebook_hash["status_type"] = facebook_post["status_type"] if facebook_post["status_type"] != nil
    facebook_hash["shares_count"] = facebook_post["shares"]["count"] if facebook_post["shares"] != nil
    facebook_hash
  end

  def facebook_story_tags(story_tags)
    story_tags_hash = {}

    story_tags.each do |offset, tag_info|
      individual_tag_hash = {}
      individual_tag_hash["name"] = tag_info[0]["name"]
      individual_tag_hash["link_to_profile"] = "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
      individual_tag_array = []
      individual_tag_array << individual_tag_hash

      story_tags_hash["#{offset}"] = individual_tag_array
    end
    story_tags_hash
  end

  def facebook_comments(comment_data)

    comments_array = []

    comment_data.each do |comment|
      comment_from_hash = {}
      comment_from_hash["name"] = comment["from"]["name"]
      comment_from_hash["link_to_profile"] = "https://www.facebook.com/app_scoped_user_id/#{comment["from"]["id"]}"
      comment_from_hash["profile_picture"] = FacebookApi.user_profile_picture(comment["from"]["id"])

      comment_hash = {}
      comment_hash["from"] = comment_from_hash
      comment_hash["message"] = comment["message"]
      comment_hash["created_time"] = "#{Time.parse(comment["created_time"])}"
      comment_hash["like_count"] = comment["like_count"]

      comments_array << comment_hash
    end
    comments_array
  end

  def facebook_original_size_image(small_image)
    if small_image.match (/s.jpg/)
      small_image.gsub!(/s.jpg/, "o.jpg")
    else
      small_image
    end
  end

  def create_twitter_hash(tweet)
    twitter_hash = {}
    twitter_hash["provider"] = "twitter"
    twitter_hash["profile_picture"] = tweet["user"]["profile_image_url_https"]
    twitter_hash["user_name"] = tweet["user"]["name"]
    twitter_hash["user_url"] = tweet["user"]["url"]
    twitter_hash["screen_name"] = tweet["user"]["screen_name"]
    twitter_hash["created_time"] = "#{Time.parse(tweet["created_at"].to_s)}"
    twitter_hash["tweet_text"] = tweet["text"]
    twitter_hash["retweet_count"] = tweet["retweet_count"].to_i
    twitter_hash["favorite_count"] = tweet["favorite_count"].to_i
    twitter_hash["link_to_tweet"] = "https://twitter.com/#{tweet["user"]["screen_name"]}/status/#{tweet["id"]}"
    twitter_hash["tweet_image"] = tweet["media"][0]["media_url"] if tweet["media"].present?
    twitter_hash
  end

  def create_instagram_hash(instagram_post)
    instagram_hash = {}
    instagram_hash["provider"] = "instagram"
    instagram_hash["profile_picture"] = instagram_post["user"]["profile_picture"]
    instagram_hash["username"] = instagram_post["user"]["username"]
    instagram_hash["user_url"] = "http://www.instagram.com/#{instagram_post["user"]["username"]}"
    instagram_hash["created_time"] = "#{Time.at(instagram_post["created_time"].to_i)}"
    instagram_hash["low_resolution_image_url"] = instagram_post["images"]["low_resolution"]["url"]
    instagram_hash["caption_text"] = instagram_post["caption"]["text"] if instagram_post["caption"] != nil
    instagram_hash["link_to_post"] = instagram_post["link"]
    instagram_hash["comments_count"] = instagram_post["comments"]["count"].to_i
    instagram_hash["comments"] = instagram_post["comments"]["data"]
    instagram_hash["likes_count"] = instagram_post["likes"]["count"].to_i
    instagram_hash
  end

end