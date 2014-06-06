class FacebookPostCreator

  def wall_post(post)
    wall_post_hash = {}
    wall_post_hash[:provider] = "facebook"
    wall_post_hash[:created_time] = parse_time(post["created_time"])
    wall_post_hash[:from] = get_from_hash(post["from"])
    wall_post_hash[:to] = get_recipient_hash(post["to"])
    wall_post_hash[:message] = post["message"]
    if post["picture"]
      wall_post_hash[:image] = get_image_hash(post["picture"])
    end
    wall_post_hash[:likes_count] = get_likes_count(post)
    wall_post_hash[:comments_count] = get_comments_count(post)
    wall_post_hash[:link_to_post] = post["actions"][0]["link"]
    wall_post_hash[:type] = "status"
    wall_post_hash[:status_type] = "wall_post"
    wall_post_hash
  end

  def photo(post)
    photo_hash = {}
    photo_hash[:provider] = "facebook"
    photo_hash[:created_time] = parse_time(post["created_time"])
    photo_hash[:from] = get_from_hash(post["from"])
    photo_hash[:message] = post["message"]
    photo_hash[:image] = get_image_hash(post["picture"])
    photo_hash[:article_link] = post["link"]
    photo_hash[:likes_count] = get_likes_count(post)
    photo_hash[:comments_count] = get_comments_count(post)
    photo_hash[:link_to_post] = post["actions"][0]["link"]
    photo_hash[:type] = "photo"
    photo_hash[:application_name] = post["application"]["name"]
    photo_hash
  end

  def default_post(post)
    facebook_hash = {}
    facebook_hash[:provider] = "facebook"
    facebook_hash[:created_time] = parse_time(post["created_time"])
    if post["from"]
      facebook_hash[:from] = get_from_hash(post["from"])
    end
    if post["to"] != nil
      facebook_hash[:to] = get_recipient_hash(post["to"])
    end
    if post["picture"] != nil
      facebook_hash[:image] = get_image_hash(post["picture"])
    end
    if post["message"] != nil
      facebook_hash[:message] = post["message"]
    end
    if post["message_tags"] != nil
      facebook_hash[:message_tags] = message_tags(post["message_tags"])
    end
    if post["name"] != nil
      facebook_hash[:article_name] = post["name"]
    end
    if post["link"] != nil
      facebook_hash[:article_link] = post["link"]
    end
    if post["description"] != nil
      facebook_hash[:description] = post["description"]
    end
    if post["caption"] != nil
      facebook_hash[:caption_text] = post["caption"]
    end
    if post["story"] != nil
      facebook_hash[:story] = post["story"]
    end
    if post["likes"] != nil
      facebook_hash[:likes_count] = get_likes_count(post)
    end
    if post["comments"] != nil
      facebook_hash[:comments_count] = get_comments_count(post)
    end
    if post["story_tags"] != nil
      facebook_hash[:story_tags] = story_tags(post["story_tags"])
    end
    if post["application"] != nil
      facebook_hash[:application_name] = post["application"]["name"]
    end
    if post["actions"] != nil
      facebook_hash[:link_to_post] = post["actions"][0]["link"]
    end
    if post["type"] != nil
      facebook_hash[:type] = post["type"]
    end
    if post["status_type"] != nil
      facebook_hash[:status_type] = post["status_type"]
    end
    if post["shares"] != nil
      facebook_hash[:shares_count] = post["shares"]["count"]
    end
    facebook_hash
  end

  private

  def get_likes_count(post)
    if post["likes"] != nil
      post["likes"]["data"].count
    else
      0
    end
  end

  def get_comments_count(post)
    if post["comments"] != nil
      post["comments"].count
    else
      0
    end
  end

  def get_image_hash(picture)
    {
      :original_sized_image => original_size_image(picture)
    }
  end

  def parse_time(created_time)
    "#{Time.parse(created_time)}"
  end

  def get_from_hash(from_data)
    {
      :id => from_data["id"],
      :link_to_profile => "https://www.facebook.com/app_scoped_user_id/#{from_data["id"]}",
      :name => from_data["name"],
    }
  end

  def get_recipient_hash(recipient_data)
    person = recipient_data["data"].first
    {
      :name => person["name"],
      :link_to_profile => "https://www.facebook.com/app_scoped_user_id/#{person["id"]}",
      :id => person["id"],
    }
  end

  def story_tags(story_tags)
    story_tags_hash = []

    story_tags.each do |_, tag_info|
      individual_tag_hash = {
        :name => tag_info[0]["name"],
        :link_to_profile => "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
      }
      story_tags_hash << individual_tag_hash
    end
    story_tags_hash
  end

  def message_tags(message_tags)
    message_tags.inject({}) do |accumulator, (offset, tag_info)|
      individual_tag_hash = {}
      individual_tag_hash[:name] = tag_info[0]["name"]
      individual_tag_hash[:link_to_profile] = "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
      accumulator[offset.to_i] = [individual_tag_hash]
      accumulator
    end
  end

  def original_size_image(small_image)
    if small_image.match (/s.jpg/)
      small_image.gsub!(/s.jpg/, "o.jpg")
    else
      small_image
    end
  end

end