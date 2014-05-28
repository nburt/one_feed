require 'oj'

class FacebookApi

  attr_reader :poster_recipient_profile_hash, :commenter_profile_hash, :posts, :next

  def initialize(access_token, pagination_id)
    @access_token = access_token
    @commenter_profile_hash = {}
    @poster_recipient_profile_hash = {}
    @pagination_id = pagination_id
    @next = nil
  end

  def timeline
    @posts = []
    hydra = Typhoeus::Hydra.hydra
    if @pagination_id == nil
      feed_request = Typhoeus::Request.new("https://graph.facebook.com/me/home?access_token=#{@access_token}&limit=5")
    else
      feed_request = Typhoeus::Request.new("https://graph.facebook.com/me/home?access_token=#{@access_token}&limit=5&until=#{@pagination_id}")
    end
    feed_request.on_complete do |response|
      @response = response
      if success?

        body = Oj.load(@response.body)
        if body["paging"] != nil
          @next = body["paging"]["next"].scan(/&until=(.{10})/).flatten[0]
        else
          @next = nil
        end
        @posts = body["data"]

        commenter_ids = get_commenter_ids

        poster_recipient_ids = get_poster_recipient_ids

        poster_recipient_ids.each do |poster_recipient_id|
          to_from_picture_request = Typhoeus::Request.new("https://graph.facebook.com/#{poster_recipient_id}/picture?redirect=false")
          to_from_picture_request.on_complete do |poster_recipient_response|
            @poster_recipient_response = poster_recipient_response
            @poster_recipient_profile_hash[poster_recipient_id] = Oj.load(@poster_recipient_response.body)["data"]["url"]
          end
          hydra.queue to_from_picture_request
        end


        commenter_ids.each do |commenter_id|
          comment_picture_request = Typhoeus::Request.new("https://graph.facebook.com/#{commenter_id}/picture?redirect=false")
          comment_picture_request.on_complete do |commenter_response|
            @commenter_response = commenter_response
            @commenter_profile_hash[commenter_id] = Oj.load(@commenter_response.body)["data"]["url"]
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

  private

  def get_commenter_ids
    commenter_ids = []
    @posts.each do |post|
      if post["comments"]
        comments = post["comments"]["data"]
        comments.each do |comment|
          commenter_ids << comment["from"]["id"]
        end
      end
    end
    commenter_ids
  end

  def get_poster_recipient_ids
    poster_recipient_ids = []
    @posts.each do |post|
      poster_recipient_ids << post["from"]["id"] if post["from"] != nil && post["from"]["id"] != nil
      poster_recipient_ids << post["to"]["id"] if post["to"] != nil && post["to"]["id"] != nil
    end
    poster_recipient_ids
  end

end