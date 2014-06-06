class FacebookPost

  def initialize(post)
    @post = post
    @facebook_post_creator = FacebookPostCreator.new
  end

  def to_hash
    if @post["type"] == "photo"
      photo_type(@post)
    elsif @post["type"] == "status"
      status_type(@post)
    elsif @post["type"] == "video"
      video_type(@post)
    else
      @facebook_post_creator.default_post(@post)
    end
  end

  private

  def status_type(post)
    if post["status_type"] == "wall_post"
      @facebook_post_creator.wall_post(post)
    elsif post["status_type"] == "mobile_status_update"
      @facebook_post_creator.mobile_update(post)
    else
      @facebook_post_creator.default_post(post)
    end
  end

  def photo_type(post)
    if post["status_type"] == "tagged_in_photo"
      @facebook_post_creator.tagged_in_photo(post)
    elsif post["status_type"] == "shared_story"
      @facebook_post_creator.photo_shared_story(post)
    else
      @facebook_post_creator.photo(post)
    end
  end

  def video_type(post)
    if post["status_type"] == "shared_story"
      @facebook_post_creator.video_shared_story(post)
    else
      @facebook_post_creator.default_post(post)
    end
  end

end