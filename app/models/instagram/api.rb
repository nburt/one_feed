module Instagram

  class Unauthorized < StandardError
  end

  class Api

    def initialize(access_token, max_id)
      @access_token = access_token
      @max_id = max_id
    end

    def get_timeline
      Response.new(
        Faraday.get("#{create_url}")
      )
    end

    private

    def create_url
      if @max_id.nil?
        "https://api.instagram.com/v1/users/self/feed?access_token=#{@access_token}&count=5"
      else
        "https://api.instagram.com/v1/users/self/feed?access_token=#{@access_token}&max_id=#{@max_id}&count=25"
      end
    end

  end

end