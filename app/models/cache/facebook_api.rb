module Cache
  class FacebookApi

    attr_reader :profile_pictures, :timeline_response

    def initialize(access_token)
      @access_token = access_token
      @profile_pictures = {}
    end

    def get_timeline
      hydra = Typhoeus::Hydra.hydra
      feed_request = Typhoeus::Request.new("https://graph.facebook.com/v2.0/me/home?limit=5&access_token=#{@access_token}")
      feed_request.on_complete do |response|
        @timeline_response = response
        if response.code != 190
          get_profile_pictures(hydra)
        end
      end
      hydra.queue feed_request
      hydra.run
    end

    private

    def get_profile_pictures(hydra)
      poster_recipient_ids = create_poster_recipient_ids

      poster_recipient_ids.each do |poster_recipient_id|
        profile_picture_request = create_profile_picture_request(poster_recipient_id)
        profile_picture_request.on_complete do |poster_recipient_response|
          create_profile_pictures_hash(poster_recipient_id, poster_recipient_response)
        end
        hydra.queue profile_picture_request
      end
    end

    def create_poster_recipient_ids
      posts = Oj.load(@timeline_response.body)["data"]
      posts_array = []
      posts.each do |post|
        posts_array << post["from"]["id"] if post["from"] != nil && post["from"]["id"] != nil
        posts_array << post["to"]["id"] if post["to"] != nil && post["to"]["id"] != nil
      end
      posts_array
    end

    def create_profile_picture_request(id)
      Typhoeus::Request.new("https://graph.facebook.com/#{id}/picture?redirect=false")
    end

    def create_profile_pictures_hash(id, response)
      @profile_pictures[id] = picture_url(response)
    end

    def picture_url(response)
      Oj.load(response.body)["data"]["url"]
    end
  end
end