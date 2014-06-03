class FacebookPost

  def initialize(post)
    @post = post
  end

  def to_hash
    facebook_hash = {}
    facebook_hash["provider"] = "facebook"
    facebook_hash["created_time"] = parse_time(@post["created_time"])
    facebook_hash["from"] = get_from_hash(@post["from"])
    if @post["to"] != nil
      facebook_hash["to"] = get_recipient_hash(@post["to"])
    end
    if @post["picture"] != nil
      facebook_hash["image"] = get_image_hash(@post["picture"])
    end
    if @post["message"] != nil
      facebook_hash["message"] = @post["message"]
    end
    if @post["message_tags"] != nil
      facebook_hash["message_tags"] = message_tags(@post["message_tags"])
    end
    if @post["name"] != nil
      facebook_hash["article_name"] = @post["name"]
    end
    if @post["link"] != nil
      facebook_hash["article_link"] = @post["link"]
    end
    if @post["description"] != nil
      facebook_hash["description"] = @post["description"]
    end
    if @post["caption"] != nil
      facebook_hash["caption_text"] = @post["caption"]
    end
    if @post["story"] != nil
      facebook_hash["story"] = @post["story"]
    end
    if @post["likes"] != nil
      facebook_hash["likes_count"] = @post["likes"]["data"].count
    else
      facebook_hash["likes_count"] = 0
    end
    if @post["comments"] != nil
      facebook_hash["comments_count"] = @post["comments"].count
    else
      facebook_hash["comments_count"] = 0
    end
    if @post["story_tags"] != nil
      facebook_hash["story_tags"] = story_tags(@post["story_tags"])
    end
    if @post["application"] != nil
      facebook_hash["application_name"] = @post["application"]["name"]
    end
    if @post["actions"] != nil
      facebook_hash["link_to_post"] = @post["actions"][0]["link"]
    end
    if @post["type"] != nil
      facebook_hash["type"] = @post["type"]
    end
    if @post["status_type"] != nil
      facebook_hash["status_type"] = @post["status_type"]
    end
    if @post["shares"] != nil
      facebook_hash["shares_count"] = @post["shares"]["count"]
    end
    facebook_hash
  end

  private

  def get_image_hash(picture)
    {"original_sized_image" => original_size_image(picture)}
  end

  def parse_time(created_time)
    "#{Time.parse(created_time)}"
  end

  def get_from_hash(from_data)
    {
      "name" => from_data["name"],
      "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/#{from_data["id"]}",
      "id" => from_data["id"]
    }
  end

  def get_recipient_hash(recipient_data)
    person = recipient_data["data"].first
    {
      "name" => person["name"],
      "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/#{person["id"]}",
      "id" => person["id"],
    }
  end

  def story_tags(story_tags)
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

  def message_tags(message_tags)
    message_tags.inject({}) do |accumulator, (offset, tag_info)|
      individual_tag_hash = {}
      individual_tag_hash["name"] = tag_info[0]["name"]
      individual_tag_hash["link_to_profile"] = "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
      accumulator[offset.to_s] = [ individual_tag_hash ]
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