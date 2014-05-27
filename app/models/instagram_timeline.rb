class InstagramTimeline

  attr_reader :authed

  def initialize(user)
    @user = user
    @authed = true
  end

  def timeline
    token = @user.tokens.find_by(provider: 'instagram')
    instagram_api = InstagramApi.new(token.access_token)
    timeline = instagram_api.get_timeline
    unless timeline.success?
      @authed = false
    end
    timeline.posts
  end

end