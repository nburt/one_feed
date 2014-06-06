class FacebookPost

  def initialize(post)
    @post = post
    @facebook_post_creator = FacebookPostCreator.new
  end

  def to_hash
    case @post["type"]
      when "photo"
        photo_type(@post)
      when "status"
        status_type(@post)
      when "video"
        video_type(@post)
      when "link"
        link_type(@post)
      else
        @facebook_post_creator.default_post(@post)
    end
  end

  private

  def link_type(post)
    case post["status_type"]
      when "shared_story"
        @facebook_post_creator.link_shared_story(post)
      else
        @facebook_post_creator.default_post(post)
    end
  end

  def status_type(post)
    case post["status_type"]
      when "wall_post"
        @facebook_post_creator.wall_post(post)
      when "mobile_status_update"
        @facebook_post_creator.mobile_update(post)
      else
        @facebook_post_creator.default_post(post)
    end
  end

  def photo_type(post)
    case post["status_type"]
      when "tagged_in_photo"
        @facebook_post_creator.tagged_in_photo(post)
      when "shared_story"
        @facebook_post_creator.photo_shared_story(post)
      when "added_photos"
        @facebook_post_creator.added_photos(post)
      else
        @facebook_post_creator.photo(post)
    end
  end

  def video_type(post)
    case post["status_type"]
      when "shared_story"
        @facebook_post_creator.video_shared_story(post)
      else
        @facebook_post_creator.default_post(post)
    end
  end

end