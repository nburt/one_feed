class FacebookApi

  attr_reader :to_from_profile_hash, :comments_profile_hash, :posts

  def initialize(access_token)
    @access_token = access_token
    @comments_profile_hash = {}
    @to_from_profile_hash = {}
  end

  def timeline
    @posts = []
    hydra = Typhoeus::Hydra.hydra
    feed_request = Typhoeus::Request.new("https://graph.facebook.com/me/home?access_token=#{@access_token}")
    feed_request.on_complete do |response|
      @response = response
      if success?
        comment_ids = []
        body = JSON.parse(@response.body)
        @posts = body["data"]

        @posts.each do |post|
          if post["comments"]
            comments = post["comments"]["data"]
            comments.each do |comment|
              comment_ids << comment["from"]["id"]
            end
          end
        end

        to_from_ids = []
        @posts.each do |post|
          to_from_ids << post["from"]["id"] if post["from"] != nil && post["from"]["id"] != nil
          to_from_ids << post["to"]["id"] if post["to"] != nil && post["to"]["id"] != nil
        end

        to_from_ids.each do |to_from_id|
          to_from_picture_request = Typhoeus::Request.new("https://graph.facebook.com/#{to_from_id}/picture?redirect=false")
          to_from_picture_request.on_complete do |to_from_response|
            @to_from_response = to_from_response
            @to_from_profile_hash[to_from_id] = JSON.parse(@to_from_response.body)["data"]["url"]
          end
          hydra.queue to_from_picture_request
        end


        comment_ids.each do |comment_id|
          comment_picture_request = Typhoeus::Request.new("https://graph.facebook.com/#{comment_id}/picture?redirect=false")
          comment_picture_request.on_complete do |comments_response|
            @comments_response = comments_response
            @comments_profile_hash[comment_id] = JSON.parse(@comments_response.body)["data"]["url"]
          end
          hydra.queue comment_picture_request
        end
      else
        return []
      end
    end

    hydra.queue feed_request
    hydra.run
  end

  def success?
    if @response.code == 200
      true
    else
      authed?
    end
  end

  def authed?
    if @response.code == 463 || @response.code == 467 || @response.code == 400
      false
    else
      true
    end
  end

end