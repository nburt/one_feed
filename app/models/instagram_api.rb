class InstagramApi

  def initialize(access_token)
    @access_token = access_token
  end

  def get_timeline
    InstagramResponse.new(
      Faraday.get("https://api.instagram.com/v1/users/self/feed?access_token=#{@access_token}")
    )
  end

  class InstagramResponse
    def initialize(response)
      @response = response
    end

    def posts
      if success?
        JSON.parse(@response.body)["data"]
      else
        []
      end
    end

    def success?
      if @response.status == 200
        true
      else
        authed?
      end
    end

    def authed?
      if @response.status == 400
        false
      else
        true
      end
    end
  end

end