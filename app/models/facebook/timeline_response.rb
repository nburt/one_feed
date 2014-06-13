module Facebook

  class TimelineResponse < Response

    attr_reader :posts, :pagination_id, :poster_recipient_profile_hash, :commenter_profile_hash

    def initialize(response)
      @response = response
      @commenter_profile_hash = {}
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

    def create_commenter_hash(id, response)
      @commenter_profile_hash[id] = picture_url(response)
    end

    def create_commenter_ids
      commenter_ids = []
      @posts.map do |post|
        if post["comments"]
          comments = post["comments"]["data"]
          comments.each do |comment|
            commenter_ids << comment["from"]["id"]
          end
        end
      end
      commenter_ids
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