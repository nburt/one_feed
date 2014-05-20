class FacebookApi

  def initialize(access_token)
    @access_token = access_token
  end

  def get_timeline
    FacebookResponse.new(
      Faraday.get("https://graph.facebook.com/me/home?access_token=#{@access_token}")
    )
  end

  def self.user_profile_picture(user_id)
    response = Faraday.get("https://graph.facebook.com/#{user_id}/picture?redirect=false")
    JSON.parse(response.body)["data"]["url"]
  end

  class FacebookResponse
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
      if @response.status == 463 || @response.status == 467
        false
      else
        true
      end
    end
  end

end