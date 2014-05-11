class InstagramApi

  def initialize(access_token)
    @access_token = access_token
  end

  def timeline
    response = Faraday.get("https://api.instagram.com/v1/users/self/feed?access_token=#{@access_token}")
    data = JSON.parse(response.body)["data"]
    data
  end

end