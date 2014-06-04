class InstagramUnauthorized < StandardError
end

class InstagramApi

  def initialize(access_token, max_id)
    @access_token = access_token
    @max_id = max_id
  end

  def get_timeline
    InstagramResponse.new(
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

class InstagramResponse
  def initialize(response)
    @response = response
  end

  def posts
    if success?
      parse_response_body["data"]
    elsif !authed?
      raise InstagramUnauthorized, "This user's token is no longer valid."
    else
      []
    end
  end

  def pagination_max_id
    if success?
      parse_response_body["pagination"]["next_max_id"]
    else
      nil
    end
  end

  def success?
    @response.status == 200
  end

  def authed?
    !(@response.status == 400)
  end

  private

  def parse_response_body
    Oj.load(@response.body)
  end

end