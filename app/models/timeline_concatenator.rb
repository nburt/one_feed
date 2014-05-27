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
    facebook_hash = {}
    facebook_hash["provider"] = "facebook"
    facebook_hash["created_time"] = parse_time(facebook_post["created_time"])
    facebook_hash["from"] = get_from_hash(facebook_post["from"])
    if facebook_post["to"] != nil
      facebook_hash["to"] = get_to_hash(facebook_post["to"])
    end
    if facebook_post["picture"] != nil
      facebook_hash["image"] = get_image_hash(facebook_post["picture"])
    end
    if facebook_post["message"] != nil
      facebook_hash["message"] = facebook_post["message"]
    end
    if facebook_post["message_tags"] != nil
      facebook_hash["message_tags"] = facebook_message_tags(facebook_post["message_tags"])
    end
    if facebook_post["name"] != nil
      facebook_hash["article_name"] = facebook_post["name"]
    end
    if facebook_post["link"] != nil
      facebook_hash["article_link"] = facebook_post["link"]
    end
    if facebook_post["description"] != nil
      facebook_hash["description"] = facebook_post["description"]
    end
    if facebook_post["caption"] != nil
      facebook_hash["caption_text"] = facebook_post["caption"]
    end
    if facebook_post["story"] != nil
      facebook_hash["story"] = facebook_post["story"]
    end
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
    if facebook_post["story_tags"] != nil
      facebook_hash["story_tags"] = facebook_story_tags(facebook_post["story_tags"])
    end
    if facebook_post["application"] != nil
      facebook_hash["application_name"] = facebook_post["application"]["name"]
    end
    if facebook_post["actions"] != nil
      facebook_hash["link_to_post"] = facebook_post["actions"][0]["link"]
    end
    if facebook_post["type"] != nil
      facebook_hash["type"] = facebook_post["type"]
    end
    if facebook_post["status_type"] != nil
      facebook_hash["status_type"] = facebook_post["status_type"]
    end
    if facebook_post["shares"] != nil
      facebook_hash["shares_count"] = facebook_post["shares"]["count"]
    end
    facebook_hash
  end

  def get_image_hash(picture)
    image_hash = {}
    image_hash["original_sized_image"] = facebook_original_size_image(picture)
    image_hash
  end

  def parse_time(created_time)
    "#{Time.parse(created_time)}"
  end

  def get_from_hash(from_data)
    from_hash = {
      "name" => from_data["name"],
      "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/#{from_data["id"]}",
      "id" => from_data["id"]
    }
    from_hash
  end

  def get_to_hash(to_data)
    to_hash = {}

    to_data["data"].each do |person|
      to_hash = {
        "name" => person["name"],
        "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/#{person["id"]}",
        "id" => person["id"],
      }
    end
    to_hash
  end

  def facebook_story_tags(story_tags)
    story_tags_hash = []

    story_tags.each do |_, tag_info|
      individual_tag_hash = {
        "name" => tag_info[0]["name"],
        "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
      }
      story_tags_hash << individual_tag_hash
    end
    story_tags_hash
  end

  def facebook_message_tags(message_tags)
    message_tags_hash = {}

    message_tags.each do |offset, tag_info|
      individual_tag_hash = {}
      individual_tag_hash["name"] = tag_info[0]["name"]
      individual_tag_hash["link_to_profile"] = "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
      individual_tag_array = []
      individual_tag_array << individual_tag_hash

      message_tags_hash["#{offset}"] = individual_tag_array
    end
    message_tags_hash
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
    twitter_hash["user_url"] = "https://twitter.com/#{tweet["user"]["screen_name"]}"
    twitter_hash["screen_name"] = tweet["user"]["screen_name"]
    twitter_hash["created_time"] = parse_time(tweet["created_at"].to_s)
    twitter_hash["tweet_text"] = tweet["text"]
    twitter_hash["retweet_count"] = tweet["retweet_count"].to_i
    twitter_hash["favorite_count"] = tweet["favorite_count"].to_i
    twitter_hash["link_to_tweet"] = "https://twitter.com/#{tweet["user"]["screen_name"]}/status/#{tweet["id"]}"
    if tweet["media"].present?
      twitter_hash["tweet_image"] = tweet["media"][0]["media_url"]
    end
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
    if instagram_post["caption"] != nil
      instagram_hash["caption_text"] = instagram_post["caption"]["text"]
    end
    instagram_hash["link_to_post"] = instagram_post["link"]
    instagram_hash["comments_count"] = instagram_post["comments"]["count"].to_i
    instagram_hash["comments"] = instagram_post["comments"]["data"]
    instagram_hash["likes_count"] = instagram_post["likes"]["count"].to_i
    if instagram_post["type"] == "video"
      instagram_hash["video"] = instagram_post["videos"]["standard_resolution"]["url"]
      instagram_hash["type"] = instagram_post["type"]
    else
      instagram_hash["type"] = "photo"
    end
    instagram_hash
  end

end