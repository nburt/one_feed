class FacebookValidator

  def initialize(token)
    @token = token
  end

  def valid?
    facebook_api = FacebookApi.new(@token.access_token)
    timeline = facebook_api.get_timeline
    timeline.authed?
  end

end