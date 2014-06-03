class InstagramPost

  def initialize(post)
    @post = post
  end

  def to_hash
    instagram_hash = {}
    instagram_hash["provider"] = "instagram"
    instagram_hash["profile_picture"] = @post["user"]["profile_picture"]
    instagram_hash["username"] = @post["user"]["username"]
    instagram_hash["user_url"] = "http://www.instagram.com/#{@post["user"]["username"]}"
    instagram_hash["created_time"] = "#{Time.at(@post["created_time"].to_i)}"
    instagram_hash["low_resolution_image_url"] = @post["images"]["low_resolution"]["url"]
    if @post["caption"] != nil
      instagram_hash["caption_text"] = @post["caption"]["text"]
    end
    instagram_hash["link_to_post"] = @post["link"]
    instagram_hash["comments_count"] = @post["comments"]["count"].to_i
    instagram_hash["comments"] = @post["comments"]["data"]
    instagram_hash["likes_count"] = @post["likes"]["count"].to_i
    if @post["type"] == "video"
      instagram_hash["video"] = @post["videos"]["standard_resolution"]["url"]
      instagram_hash["type"] = @post["type"]
    else
      instagram_hash["type"] = "photo"
    end
    instagram_hash
  end

end