module Cache
  class TimelineFormatter

    attr_reader :timeline, :unauthed_accounts, :twitter_pagination_id, :facebook_pagination_id, :instagram_max_id, :facebook_profile_pictures

    def initialize(post)
      @post = post
      @unauthed_accounts = []
      @facebook_profile_pictures = {}
      format!
    end

    private

    def format!
      structs = create_structs(@post)
      if structs[2] != []
        set_facebook_profile_pictures
      end
      @timeline = TimelineConcatenator.new.merge(twitter_posts(structs[0]), instagram_posts(structs[1]), facebook_posts(structs[2]))
    end

    def set_facebook_profile_pictures
      @facebook_profile_pictures = @post.post_hash["facebook"]["profile_pictures"]
    end

    def twitter_posts(post_structs)
      posts = []
      if post_structs == []
        []
      elsif post_structs.code == 400
        @unauthed_accounts << "twitter"
      else
        set_twitter_pagination_id(post_structs.body)
        post_structs.body.map do |post|
          posts << Twitter::Post.from(post)
        end
      end
      posts
    end

    def set_twitter_pagination_id(body)
      if body.last.nil?
        @twitter_pagination_id = nil
      else
        @twitter_pagination_id = body.last["id"]
      end
    end

    def instagram_posts(post_structs)
      posts = []
      if post_structs == []
        []
      elsif post_structs.code == 401
        @unauthed_accounts << "instagram"
      else
        response = Instagram::Response.new(post_structs)
        posts = response.posts
        @instagram_max_id = response.pagination_max_id
      end

      if posts.empty?
        posts
      else
        posts.map do |post|
          Instagram::Post.from(post)
        end
      end
    end

    def facebook_posts(post_structs)
      posts = []
      if post_structs == []
        []
      elsif post_structs.code == 190
        @unauthed_accounts << "facebook"
      else
        response = Facebook::TimelineResponse.new(post_structs)
        posts = response.posts_response
        @facebook_pagination_id = response.pagination_id
      end

      if posts.empty?
        posts
      else
        posts.map do |post|
          Facebook::Post.from(post)
        end
      end
    end

    def create_structs(post)
      [
        twitter_struct(post.post_hash["twitter"]),
        instagram_struct(post.post_hash["instagram"]),
        facebook_struct(post.post_hash["facebook"])
      ]
    end

    def instagram_struct(post_hash)
      if post_hash
        instagram = Struct.new(:body, :code)
        instagram.new(post_hash["body"], post_hash["code"])
      else
        []
      end
    end

    def facebook_struct(post_hash)
      if post_hash
        facebook = Struct.new(:body, :code)
        facebook.new(post_hash["body"], post_hash["code"])
      else
        []
      end
    end

    def twitter_struct(post_hash)
      if post_hash
        twitter = Struct.new(:body, :code)
        twitter.new(post_hash["body"], post_hash["code"])
      else
        []
      end
    end
  end
end