module Facebook

  class TimelineResponse < Response

    attr_reader :posts, :pagination_id, :poster_recipient_profile_hash

    def initialize(response)
      @response = response
      @poster_recipient_profile_hash = {}
      @posts = []
    end

    def posts_response
      body = parse_json(@response.body)
      set_pagination_id(body)
      @posts = body["data"]
    end

    def create_poster_recipient_hash(id, response)
      @poster_recipient_profile_hash[id] = picture_url(response)
    end

    def create_poster_recipient_ids
      poster_recipient_ids = []
      @posts.each do |post|
        poster_recipient_ids << post["from"]["id"] if post["from"] != nil && post["from"]["id"] != nil
        poster_recipient_ids << post["to"]["id"] if post["to"] != nil && post["to"]["id"] != nil
      end
      poster_recipient_ids
    end

    private

    def set_pagination_id(body)
      if body["paging"] != nil
        @pagination_id = body["paging"]["next"].scan(/&until=(.{10})/).flatten[0]
      else
        @pagination_id = nil
      end
    end

  end

end