module Facebook

  class PostResponse < Response

    attr_reader :post, :poster_profile_picture, :commenter_profile_hash

    def initialize(response)
      @response = response
      @post = []
      @commenter_profile_hash = {}
    end

    def single_post_response
      @post = parse_json(@response.body)
    end

    def create_poster_profile_picture(response)
      @poster_profile_picture = {profile_picture_url: picture_url(response)}
    end

    def created_post
      @response
    end

    def parse_data
      @post = parse_json(@response.body)["data"]
    end

    def create_commenter_hash(id, response)
      @commenter_profile_hash[id] = picture_url(response)
    end

    def create_commenter_ids
      commenter_ids = []
      @post.each do |comment|
        commenter_ids << comment["from"]["id"]
      end
      commenter_ids
    end

  end

end