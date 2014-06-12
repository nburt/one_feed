module Facebook
  class Response

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
      @poster_recipient_profile_hash[id] = picture_url("poster_recipient", response)
    end

    def create_commenter_hash(id, response)
      @commenter_profile_hash[id] = picture_url("commenter", response)
    end

    def success?
      @response.code == 200
    end

    def parse
      parse_json(@response.body)
    end

    def authed?
      !(@response.code == 463 || @response.code == 467 || @response.code == 400)
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

    def parse_json(data)
      Oj.load(data)
    end

    def set_pagination_id(body)
      if body["paging"] != nil
        @pagination_id = body["paging"]["next"].scan(/&until=(.{10})/).flatten[0]
      else
        @pagination_id = nil
      end
    end

    def picture_url(type, response)
      if type == "commenter"
        parse_json(response.body)["data"]["url"]
      elsif type == "poster_recipient"
        parse_json(response.body)["data"]["url"]
      end
    end

  end
end