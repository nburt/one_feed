module Instagram

  class Unauthorized < StandardError
  end

  class Api

    def initialize(access_token, max_id = nil)
      @access_token = access_token
      @max_id = max_id
    end

    def get_timeline
      Response.new(
        Typhoeus.get("#{create_url}")
      )
    end

    def get_comments(media_id)
      Response.new(
        Typhoeus.get("https://api.instagram.com/v1/media/#{media_id}/comments?access_token=#{@access_token}")
      )
    end

    def like_post(media_id)
      Typhoeus.post("https://api.instagram.com/v1/media/#{media_id}/likes?access_token=#{@access_token}")
    end

    def get_post(media_id)
      Response.new(
        Typhoeus.get("https://api.instagram.com/v1/media/#{media_id}/?access_token=#{@access_token}")
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