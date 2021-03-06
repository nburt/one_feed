module Facebook

  class Unauthorized < StandardError
  end

  class Api

    attr_reader :facebook_timeline_response, :facebook_post_response

    def initialize(access_token, pagination_id = nil)
      @access_token = access_token
      @pagination_id = pagination_id
    end

    def timeline
      hydra = Typhoeus::Hydra.hydra

      @facebook_timeline_response = []

      feed_request = create_feed_request
      feed_request.on_complete do |response|
        @facebook_timeline_response = TimelineResponse.new(response)
        if @facebook_timeline_response.success?
          @facebook_timeline_response.posts_response
          create_poster_recipient_id_request(hydra)
        elsif !@facebook_timeline_response.authed?
          raise Unauthorized, "This user's token is no longer valid."
        else
          return []
        end
      end

      hydra.queue feed_request
      hydra.run
    end

    def create_post(post_content)
      post_content.gsub!(" ", "+")
      @facebook_post_response = PostResponse.new(Typhoeus.post("https://graph.facebook.com/v2.0/me/feed?access_token=#{@access_token}&message=#{post_content}"))
      if @facebook_post_response.success?
        get_post_id(@facebook_post_response.created_post)
      elsif !@facebook_post_response.authed?
        raise Unauthorized, "This user's token is no longer valid."
      else
        false
      end
    end

    def like_post(post_id)
      Typhoeus.post("https://graph.facebook.com/v2.0/#{post_id}/likes?access_token=#{@access_token}")
    end

    def get_post(post_id)
      hydra = Typhoeus::Hydra.hydra

      @facebook_post_response = []

      post_request = create_post_request(post_id)
      post_request.on_complete do |response|
        @facebook_post_response = PostResponse.new(response)
        if @facebook_post_response.success?
          @facebook_post_response.single_post_response
          create_poster_profile_request(hydra)
        elsif !@facebook_post_response.authed?
          raise Unauthorized, "This user's token is no longer valid."
        else
          return []
        end
      end

      hydra.queue post_request
      hydra.run
    end

    def get_comments(post_id)
      hydra = Typhoeus::Hydra.hydra

      @facebook_post_response = []

      comments_request = create_comments_request(post_id)
      comments_request.on_complete do |response|
        @facebook_post_response = PostResponse.new(response)
        @facebook_post_response.parse_data
        create_commenter_id_request(hydra)
      end

      hydra.queue comments_request
      hydra.run
    end

    private

    def get_post_id(created_post)
      Oj.load(created_post.response_body)["id"]
    end

    def create_post_request(post_id)
      Typhoeus::Request.new("https://graph.facebook.com/v2.0/#{post_id}?access_token=#{@access_token}")
    end

    def create_feed_request
      if @pagination_id.nil?
        Typhoeus::Request.new("https://graph.facebook.com/v2.0/me/home?limit=5&access_token=#{@access_token}")
      else
        Typhoeus::Request.new("https://graph.facebook.com/v2.0/me/home?limit=25&access_token=#{@access_token}&until=#{@pagination_id}")
      end
    end

    def create_poster_profile_request(hydra)
      poster_id = @facebook_post_response.post["from"]["id"]
      profile_picture_request = create_profile_picture_request(poster_id)
      profile_picture_request.on_complete do |response|
        @facebook_post_response.create_poster_profile_picture(response)
      end
      hydra.queue profile_picture_request
    end

    def create_comments_request(post_id)
      Typhoeus::Request.new("https://graph.facebook.com/v2.0/#{post_id}/comments?access_token=#{@access_token}")
    end

    def create_profile_picture_request(id)
      Typhoeus::Request.new("https://graph.facebook.com/#{id}/picture?redirect=false")
    end

    def create_poster_recipient_id_request(hydra)
      poster_recipient_ids = @facebook_timeline_response.create_poster_recipient_ids

      poster_recipient_ids.each do |poster_recipient_id|
        to_from_picture_request = create_profile_picture_request(poster_recipient_id)
        to_from_picture_request.on_complete do |poster_recipient_response|
          @facebook_timeline_response.create_poster_recipient_hash(poster_recipient_id, poster_recipient_response)
        end
        hydra.queue to_from_picture_request
      end
    end

    def create_commenter_id_request(hydra)
      commenter_ids = @facebook_post_response.create_commenter_ids

      commenter_ids.each do |commenter_id|
        comment_picture_request = create_profile_picture_request(commenter_id)
        comment_picture_request.on_complete do |commenter_response|
          @facebook_post_response.create_commenter_hash(commenter_id, commenter_response)
        end
        hydra.queue comment_picture_request
      end
    end

  end
end