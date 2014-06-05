class FacebookPost

  def initialize(post)
    @post = post
    @facebook_post_creator = FacebookPostCreator.new
  end

  def to_hash
    if @post["type"] == "photo"
      photo_type(@post)
    else
      @facebook_post_creator.default_post(@post)
    end
  end

  private

  def photo_type(post)
    if post["type"] == "photo" && post["status_type"] == "tagged_in_photo"
      @facebook_post_creator.default_post(post)
    else
      @facebook_post_creator.photo(post)
    end
  end

end