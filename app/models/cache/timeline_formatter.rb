module Cache
  class TimelineFormatter

    attr_reader :timeline, :unauthed_accounts, :twitter_pagination_id, :facebook_pagination_id, :instagram_max_id, :facebook_profile_pictures

    def initialize(post)
      @post = post
      @unauthed_accounts = []
      @facebook_profile_pictures = {}
    end

    def format
      structs = create_structs(@post)
      set_facebook_profile_pictures
      @timeline = TimelineConcatenator.new.merge(twitter_posts(structs[2]), instagram_posts(structs[0]), facebook_posts(structs[1]))
    end

    private

    def set_facebook_profile_pictures
      @facebook_profile_pictures = @post.post_array[1]["profile_pictures"]
    end

    def twitter_posts(post_structs)
      if post_structs.code == 400
        @unauthed_accounts << "twitter"
      else
        set_twitter_pagination_id(post_structs.body["body"])
        post_structs.body["body"].map do |post|
          Twitter::Post.from(post)
        end
      end
    end

    def set_twitter_pagination_id(post_structs)
      if post_structs.last.nil?
        @twitter_pagination_id = nil
      else
        @twitter_pagination_id = post_structs.last["id"]
      end
    end

    def instagram_posts(post_structs)
      response = Instagram::Response.new(post_structs)
      posts = []
      if !response.authed?
        @unauthed_accounts << "instagram"
      else
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
      response = Facebook::TimelineResponse.new(post_structs)
      posts = []
      if !response.authed?
        @unauthed_accounts << "facebook"
      else
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
        instagram_struct(post.post_array[0]),
        facebook_struct(post.post_array[1]),
        twitter_struct(post.post_array[2])
      ]
    end

    def instagram_struct(post_array)
      Struct.new("Instagram", :body, :code)
      Struct::Instagram.new(post_array["body"], post_array["code"])
    end

    def facebook_struct(post_array)
      Struct.new("Facebook", :body, :code)
      Struct::Facebook.new(post_array["body"], post_array["code"])
    end

    def twitter_struct(post_array)
      Struct.new("Twitter", :body, :code)
      Struct::Twitter.new(post_array["body"], post_array["code"])
    end
  end
end