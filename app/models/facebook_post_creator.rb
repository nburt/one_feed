class FacebookPostCreator

  def added_photos(post)
    added_photos_hash = {}
    provider(added_photos_hash)
    created_time(added_photos_hash, post["created_time"])
    from_hash(added_photos_hash, post["from"])
    added_photos_hash[:message] = post["message"]
    added_photos_hash[:image] = get_image_hash(post["picture"])
    added_photos_hash[:photo_in_album_link] = post["link"]
    added_photos_hash[:album_name] = post["name"]
    added_photos_hash[:likes_count] = get_likes_count(post)
    added_photos_hash[:comments_count] = get_comments_count(post)
    link_to_post(added_photos_hash, post)
    added_photos_hash[:type] = "photo"
    added_photos_hash[:status_type] = "added_photos"
    added_photos_hash[:application_name] = post["application"]["name"]
    added_photos_hash
  end

  def link_shared_story(post)
    link_shared_story_hash = {}
    provider(link_shared_story_hash)
    created_time(link_shared_story_hash, post["created_time"])
    from_hash(link_shared_story_hash, post["from"])
    if post["to"]
      link_shared_story_hash[:to] = get_recipient_hash(post["to"])
    end
    link_shared_story_hash[:message] = post["message"]
    link_shared_story_hash[:image] = get_image_hash(post["picture"])
    link_shared_story_hash[:article_link] = post["link"]
    link_shared_story_hash[:article_name] = post["name"]
    link_shared_story_hash[:article_caption] = post["caption"]
    link_shared_story_hash[:article_description] = post["description"]
    link_shared_story_hash[:likes_count] = get_likes_count(post)
    link_shared_story_hash[:comments_count] = get_comments_count(post)
    link_to_post(link_shared_story_hash, post)
    link_shared_story_hash[:type] = "link"
    link_shared_story_hash[:status_type] = "shared_story"
    link_shared_story_hash
  end

  def video_shared_story(post)
    video_shared_story_hash = {}
    provider(video_shared_story_hash)
    created_time(video_shared_story_hash, post["created_time"])
    from_hash(video_shared_story_hash, post["from"])
    if post["to"]
      video_shared_story_hash[:to] = get_recipient_hash(post["to"])
    end
    video_shared_story_hash[:message] = post["message"]
    video_shared_story_hash[:video_link] = post["link"]
    video_shared_story_hash[:source] = post["source"]
    video_shared_story_hash[:video_name] = post["name"]
    video_shared_story_hash[:video_description] = post["description"]
    video_shared_story_hash[:likes_count] = get_likes_count(post)
    video_shared_story_hash[:comments_count] = get_comments_count(post)
    link_to_post(video_shared_story_hash, post)
    video_shared_story_hash[:type] = "video"
    video_shared_story_hash[:status_type] = "shared_story"
    video_shared_story_hash
  end

  def photo_shared_story(post)
    photo_shared_story_hash = {}
    provider(photo_shared_story_hash)
    created_time(photo_shared_story_hash, post["created_time"])
    from_hash(photo_shared_story_hash, post["from"])
    photo_shared_story_hash[:story] = post["story"]
    photo_shared_story_hash[:story_tags] = story_tags(post["story_tags"])
    photo_shared_story_hash[:image] = get_image_hash(post["picture"])
    photo_shared_story_hash[:article_link] = post["link"]
    link_to_post(photo_shared_story_hash, post)
    photo_shared_story_hash[:likes_count] = get_likes_count(post)
    photo_shared_story_hash[:comments_count] = get_comments_count(post)
    photo_shared_story_hash[:type] = "photo"
    photo_shared_story_hash[:status_type] = "shared_story"
    photo_shared_story_hash[:application_name] = post["application"]["name"]
    photo_shared_story_hash
  end

  def tagged_in_photo(post)
    tagged_in_photo_hash = {}
    provider(tagged_in_photo_hash)
    created_time(tagged_in_photo_hash, post["created_time"])
    from_hash(tagged_in_photo_hash, post["from"])
    if post["message"]
      tagged_in_photo_hash[:message] = post["message"]
    end
    tagged_in_photo_hash[:story] = post["story"]
    tagged_in_photo_hash[:story_tags] = story_tags(post["story_tags"])
    tagged_in_photo_hash[:image] = get_image_hash(post["picture"])
    tagged_in_photo_hash[:article_link] = post["link"]
    tagged_in_photo_hash[:likes_count] = get_likes_count(post)
    tagged_in_photo_hash[:comments_count] = get_comments_count(post)
    if post["actions"]
      link_to_post(tagged_in_photo_hash, post)
    end
    tagged_in_photo_hash[:type] = "photo"
    tagged_in_photo_hash[:status_type] = "tagged_in_photo"
    tagged_in_photo_hash[:application_name] = post["application"]["name"]
    tagged_in_photo_hash
  end

  def mobile_update(post)
    mobile_update_hash = {}
    provider(mobile_update_hash)
    created_time(mobile_update_hash, post["created_time"])
    from_hash(mobile_update_hash, post["from"])
    if post["to"]
      mobile_update_hash[:to] = get_recipient_hash(post["to"])
    end
    mobile_update_hash[:message] = post["message"]
    mobile_update_hash[:likes_count] = get_likes_count(post)
    mobile_update_hash[:comments_count] = get_comments_count(post)
    link_to_post(mobile_update_hash, post)
    mobile_update_hash[:type] = "status"
    mobile_update_hash[:status_type] = "mobile_status_update"
    if post["application"]
      mobile_update_hash[:application_name] = post["application"]["name"]
    end
    mobile_update_hash
  end

  def wall_post(post)
    wall_post_hash = {}
    provider(wall_post_hash)
    created_time(wall_post_hash, post["created_time"])
    from_hash(wall_post_hash, post["from"])
    wall_post_hash[:to] = get_recipient_hash(post["to"])
    wall_post_hash[:message] = post["message"]
    if post["picture"]
      wall_post_hash[:image] = get_image_hash(post["picture"])
    end
    wall_post_hash[:likes_count] = get_likes_count(post)
    wall_post_hash[:comments_count] = get_comments_count(post)
    link_to_post(wall_post_hash, post)
    wall_post_hash[:type] = "status"
    wall_post_hash[:status_type] = "wall_post"
    wall_post_hash
  end

  def photo(post)
    photo_hash = {}
    provider(photo_hash)
    created_time(photo_hash, post["created_time"])
    from_hash(photo_hash, post["from"])
    if post["message"]
      photo_hash[:message] = post["message"]
    end
    if post["story"]
      photo_hash[:story] = post["story"]
      photo_hash[:story_tags] = story_tags(post["story_tags"])
    end
    photo_hash[:image] = get_image_hash(post["picture"])
    photo_hash[:article_link] = post["link"]
    photo_hash[:likes_count] = get_likes_count(post)
    photo_hash[:comments_count] = get_comments_count(post)
    link_to_post(photo_hash, post)
    photo_hash[:type] = "photo"
    if post["application"]
      photo_hash[:application_name] = post["application"]["name"]
    end
    photo_hash
  end

  def default_post(post)
    facebook_hash = {}
    provider(facebook_hash)
    created_time(facebook_hash, post["created_time"])
    if post["from"]
      from_hash(facebook_hash, post["from"])
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
      link_to_post(facebook_hash, post)
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

  def link_to_post(hash, post)
    hash[:link_to_post] = post["actions"][0]["link"]
  end

  def created_time(hash, time)
    hash[:created_time] = parse_time(time)
  end

  def provider(hash)
    hash[:provider] = "facebook"
  end

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

  def from_hash(hash, from_data)
    hash[:from] = {
      :id => from_data["id"],
      :link_to_profile => "https://www.facebook.com/app_scoped_user_id/#{from_data["id"]}",
      :name => from_data["name"],
    }
  end

  def get_recipient_hash(recipient_data)
    person = recipient_data["data"].first
    {
      :id => person["id"],
      :link_to_profile => "https://www.facebook.com/app_scoped_user_id/#{person["id"]}",
      :name => person["name"],
    }
  end

  def story_tags(story_tags)
    story_tags_hash = []

    story_tags.each do |_, tag_info|
      individual_tag_hash = {}
      individual_tag_hash[:name] = tag_info[0]["name"]
      if tag_info[0]["type"] == "user"
        individual_tag_hash[:link_to_profile] = "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
      end
      individual_tag_hash[:type] = tag_info[0]["type"]
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