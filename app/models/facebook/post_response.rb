module Facebook

  class PostResponse < Response

    attr_reader :post, :poster_profile_picture

    def initialize(response)
      @response = response
    end

    def single_post_response
      @post = parse_json(@response.body)
    end

    def create_poster_profile_picture(response)
      @poster_profile_picture = {profile_picture_url: picture_url(response)}
    end

  end

end