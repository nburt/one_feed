class FacebookPost < TimelineEntry

  def self.from(facebook_api_hash)
    FacebookDefaultPost.from(facebook_api_hash)
  end

  def provider
    "facebook"
  end

  def post_type
    @post.type
  end

end