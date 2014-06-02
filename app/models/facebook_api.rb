require 'oj'

class FacebookApi

  attr_reader :poster_recipient_profile_hash, :commenter_profile_hash, :posts, :pagination_id

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

    feed_request = typheous_request("feed_request")
    feed_request.on_complete do |response|
      @response = response
      if success?
        body = parse_json(@response.body)
        set_pagination_id(body)
        @posts = body["data"]
        poster_recipient_id_request(hydra)
        commenter_id_request(hydra)
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

  def typheous_request(type, id = nil)
    if type == "feed_request"
      make_feed_request
    elsif type == "profile_picture_request"
      make_profile_picture_request(id)
    end
  end

  def make_feed_request
    if @pagination_id.nil?
      Typhoeus::Request.new("https://graph.facebook.com/v2.0/me/home?limit=5&access_token=#{@access_token}")
    else
      Typhoeus::Request.new("https://graph.facebook.com/v2.0/me/home?limit=25&access_token=#{@access_token}&until=#{@pagination_id}")
    end
  end

  def make_profile_picture_request(id)
    Typhoeus::Request.new("https://graph.facebook.com/#{id}/picture?redirect=false")
  end

  def poster_recipient_id_request(hydra)
    poster_recipient_ids = get_poster_recipient_ids

    poster_recipient_ids.each do |poster_recipient_id|
      to_from_picture_request = typheous_request("profile_picture_request", poster_recipient_id)
      to_from_picture_request.on_complete do |poster_recipient_response|
        @poster_recipient_response = poster_recipient_response
        @poster_recipient_profile_hash[poster_recipient_id] = picture_url("poster_recipient")
      end
      hydra.queue to_from_picture_request
    end
  end

  def commenter_id_request(hydra)
    commenter_ids = get_commenter_ids

    commenter_ids.each do |commenter_id|
      comment_picture_request = typheous_request("profile_picture_request", commenter_id)
      comment_picture_request.on_complete do |commenter_response|
        @commenter_response = commenter_response
        @commenter_profile_hash[commenter_id] = picture_url("commenter")
      end
      hydra.queue comment_picture_request
    end
  end

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

  def picture_url(type)
    if type == "commenter"
      parse_json(@commenter_response.body)["data"]["url"]
    elsif type == "poster_recipient"
      parse_json(@poster_recipient_response.body)["data"]["url"]
    end
  end

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

end