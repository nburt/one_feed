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
    else
      @facebook_post_creator.default_post(@post)
    end
  end

  private

  def status_type(post)
    if post["status_type"] == "wall_post"
      @facebook_post_creator.wall_post(post)
    else
      @facebook_post_creator.default_post(post)
    end
  end

  def photo_type(post)
    if post["status_type"] == "tagged_in_photo"
      @facebook_post_creator.default_post(post)
    else
      @facebook_post_creator.photo(post)
    end
  end

end