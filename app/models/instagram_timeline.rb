class InstagramTimeline

  attr_reader :authed, :pagination_max_id

  def initialize(user)
    @user = user
    @authed = true
  end

  def posts(max_id)
    token = @user.tokens.find_by(provider: 'instagram')
    instagram_api = InstagramApi.new(token.access_token, max_id)
    posts = []
    begin
      timeline = instagram_api.get_timeline
      posts = timeline.posts
    rescue InstagramUnauthorized
      @authed = false
    end
    posts
  end

end