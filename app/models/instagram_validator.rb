class InstagramValidator

  def initialize(token)
    @token = token
  end

  def valid?
    instagram_api = InstagramApi.new(@token.access_token)
    timeline = instagram_api.get_timeline
    timeline.authed?
  end

end
