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