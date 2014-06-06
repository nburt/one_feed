class FacebookPostCreator

  def added_photos(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    post_hash[:message] = post["message"]
    image_hash(post_hash, post)
    post_hash[:photo_in_album_link] = post["link"]
    post_hash[:album_name] = post["name"]
    likes_count(post_hash, post)
    comments_count(post_hash, post)
    link_to_post(post_hash, post)
    types(post_hash, post)
    if post["application"]
      post_hash[:application_name] = post["application"]["name"]
    end
    post_hash
  end

  def link_shared_story(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    if post["to"]
      post_hash[:to] = get_recipient_hash(post["to"])
    end
    post_hash[:message] = post["message"]
    image_hash(post_hash, post)
    post_hash[:article_link] = post["link"]
    post_hash[:article_name] = post["name"]
    post_hash[:article_caption] = post["caption"]
    post_hash[:article_description] = post["description"]
    likes_count(post_hash, post)
    comments_count(post_hash, post)
    link_to_post(post_hash, post)
    types(post_hash, post)
    post_hash
  end

  def video_shared_story(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    if post["to"]
      post_hash[:to] = get_recipient_hash(post["to"])
    end
    post_hash[:message] = post["message"]
    post_hash[:video_link] = post["link"]
    post_hash[:source] = post["source"]
    post_hash[:video_name] = post["name"]
    post_hash[:video_description] = post["description"]
    likes_count(post_hash, post)
    comments_count(post_hash, post)
    link_to_post(post_hash, post)
    types(post_hash, post)
    post_hash
  end

  def photo_shared_story(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    story_and_tags(post_hash, post)
    image_hash(post_hash, post)
    post_hash[:article_link] = post["link"]
    link_to_post(post_hash, post)
    likes_count(post_hash, post)
    comments_count(post_hash, post)
    types(post_hash, post)
    post_hash[:application_name] = post["application"]["name"]
    post_hash
  end

  def tagged_in_photo(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    if post["message"]
      post_hash[:message] = post["message"]
    end
    post_hash[:story] = post["story"]
    post_hash[:story_tags] = story_tags(post["story_tags"])
    image_hash(post_hash, post)
    post_hash[:article_link] = post["link"]
    likes_count(post_hash, post)
    comments_count(post_hash, post)
    if post["actions"]
      link_to_post(post_hash, post)
    end
    types(post_hash, post)
    post_hash[:application_name] = post["application"]["name"]
    post_hash
  end

  def mobile_update(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    if post["to"]
      post_hash[:to] = get_recipient_hash(post["to"])
    end
    post_hash[:message] = post["message"]
    likes_count(post_hash, post)
    comments_count(post_hash, post)
    link_to_post(post_hash, post)
    types(post_hash, post)
    if post["application"]
      post_hash[:application_name] = post["application"]["name"]
    end
    post_hash
  end

  def wall_post(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    post_hash[:to] = get_recipient_hash(post["to"])
    post_hash[:message] = post["message"]
    if post["picture"]
      image_hash(post_hash, post)
    end
    likes_count(post_hash, post)
    comments_count(post_hash, post)
    link_to_post(post_hash, post)
    types(post_hash, post)
    post_hash
  end

  def photo(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    if post["message"]
      post_hash[:message] = post["message"]
    end
    if post["story"]
      story_and_tags(post_hash, post)
    end
    image_hash(post_hash, post)
    post_hash[:article_link] = post["link"]
    likes_count(post_hash, post)
    comments_count(post_hash, post)
    link_to_post(post_hash, post)
    types(post_hash, post)
    if post["application"]
      post_hash[:application_name] = post["application"]["name"]
    end
    post_hash
  end

  def default_post(post)
    post_hash = {}
    create_base_hash(post_hash, post)
    if post["to"] != nil
      post_hash[:to] = get_recipient_hash(post["to"])
    end
    if post["picture"] != nil
      image_hash(post_hash, post)
    end
    if post["message"] != nil
      post_hash[:message] = post["message"]
    end
    if post["message_tags"] != nil
      post_hash[:message_tags] = message_tags(post["message_tags"])
    end
    if post["name"] != nil
      post_hash[:article_name] = post["name"]
    end
    if post["link"] != nil
      post_hash[:article_link] = post["link"]
    end
    if post["description"] != nil
      post_hash[:description] = post["description"]
    end
    if post["caption"] != nil
      post_hash[:caption_text] = post["caption"]
    end
    if post["story"] != nil
      story_and_tags(post_hash, post)
    end
    if post["likes"] != nil
      likes_count(post_hash, post)
    end
    if post["comments"] != nil
      comments_count(post_hash, post)
    end
    if post["application"] != nil
      post_hash[:application_name] = post["application"]["name"]
    end
    if post["actions"] != nil
      link_to_post(post_hash, post)
    end
    types(post_hash, post)
    if post["shares"] != nil
      post_hash[:shares_count] = post["shares"]["count"]
    end
    post_hash
  end

  private

  def create_base_hash(hash, post)
    provider(hash)
    created_time(hash, post["created_time"])
    if post["from"]
      from_hash(hash, post["from"])
    end
  end

  def types(hash, post)
    hash[:type] = post["type"]
    if post["status_type"]
      hash[:status_type] = post["status_type"]
    end
  end

  def link_to_post(hash, post)
    hash[:link_to_post] = post["actions"][0]["link"]
  end

  def created_time(hash, time)
    hash[:created_time] = parse_time(time)
  end

  def provider(hash)
    hash[:provider] = "facebook"
  end

  def likes_count(hash, post)
    if post["likes"] != nil
      hash[:likes_count] = post["likes"]["data"].count
    else
      hash[:likes_count] = 0
    end
  end

  def comments_count(hash, post)
    if post["comments"] != nil
      hash[:comments_count] = post["comments"]["data"].count
    else
      hash[:comments_count] = 0
    end
  end

  def image_hash(hash, post)
    hash[:image] = {
      :original_sized_image => original_size_image(post["picture"])
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

  def story_and_tags(hash, post)
    hash[:story] = post["story"]
    hash[:story_tags] = story_tags(post["story_tags"])
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