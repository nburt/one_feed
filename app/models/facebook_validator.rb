class FacebookValidator

  def initialize(token)
    @token = token
  end

  def valid?
    facebook_api = FacebookApi.new(@token.access_token)
    facebook_api.timeline
    facebook_api.authed?
  end

end