module Facebook
  class DefaultPost < TimelineEntry

    def self.from(post)
      new(post)
    end

    def initialize(post)
      @post = post
      @created_time = Time.parse(post["created_time"])
    end

    def provider
      "facebook"
    end

    def id
      @post["id"]
    end

    def from
      from_hash(@post["from"])
    end

    def to
      if @post["to"]
        recipient_hash(@post["to"])
      end
    end

    def image
      if @post["picture"]
        original_size_image(@post["picture"])
      end
    end

    def message
      if @post["message"]
        @post["message"]
      end
    end

    def message_tags
      if @post["message_tags"]
        get_message_tags(post["message_tags"])
      end
    end

    def article_name
      if @post["name"]
        @post["name"]
      end
    end

    def article_link
      if @post["link"]
        @post["link"]
      end
    end

    def description
      if @post["description"]
        @post["description"]
      end
    end

    def caption_text
      if @post["caption"]
        @post["caption"]
      end
    end

    def story
      if @post["story"]
        @post["story"]
      end
    end

    def story_tags
      if @post["story"]
        get_story_tags(@post)
      end
    end

    def likes_count
      get_likes_count(@post)
    end

    def comments_count
      get_comments_count(@post)
    end

    def comments
      nil
    end

    def application_name
      if @post["application"]
        @post["application"]["name"]
      end
    end

    def link_to_post
      if @post["actions"]
        @post["actions"][0]["link"]
      end
    end

    def shares_count
      if @post["shares"]
        @post["shares"]["count"]
      end
    end

    def type
      @post["type"]
    end

    def status_type
      if @post["status_type"]
        @post["status_type"]
      end
    end

    private

    def from_hash(from_data)
      {
        :id => from_data["id"],
        :link_to_profile => "https://www.facebook.com/app_scoped_user_id/#{from_data["id"]}",
        :name => from_data["name"],
      }
    end

    def recipient_hash(recipient_data)
      person = recipient_data["data"].first
      {
        :id => person["id"],
        :link_to_profile => "https://www.facebook.com/app_scoped_user_id/#{person["id"]}",
        :name => person["name"],
      }
    end

    def original_size_image(small_image)
      if small_image.match (/s.jpg/)
        small_image.gsub!(/s.jpg/, "o.jpg")
      else
        small_image
      end
    end

    def get_message_tags(message_tags)
      message_tags.inject({}) do |accumulator, (offset, tag_info)|
        individual_tag_hash = {}
        individual_tag_hash[:name] = tag_info[0]["name"]
        individual_tag_hash[:link_to_profile] = "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
        accumulator[offset.to_i] = [individual_tag_hash]
        accumulator
      end
    end

    def get_story_tags(post)
      story_tags_array(post["story_tags"])
    end

    def story_tags_array(story_tags)
      story_tags_hash = []

      story_tags.each do |_, tag_info|
        individual_tag_hash = {}
        individual_tag_hash[:name] = tag_info[0]["name"]
        if tag_info[0]["type"] == "user"
          individual_tag_hash[:link_to_profile] = "https://www.facebook.com/app_scoped_user_id/#{tag_info[0]["id"]}"
        end
        individual_tag_hash[:type] = tag_info[0]["type"]
        story_tags_hash << individual_tag_hash
      end
      story_tags_hash
    end

    def get_likes_count(post)
      if post["likes"]
        post["likes"]["data"].count
      else
        0
      end
    end

    def get_comments_count(post)
      if post["comments"]
        post["comments"].count
      else
        0
      end
    end
  end
end
