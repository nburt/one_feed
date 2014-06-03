class TimelineConcatenator

  def merge(twitter_timeline, instagram_timeline, facebook_timeline)
    new_timeline = []

    twitter_timeline.each do |tweet|
      tweet_hash = TwitterPost.new(tweet).to_hash
      new_timeline << tweet_hash if tweet_hash.present?
    end

    instagram_timeline.each do |instagram_post|
      instagram_post_hash = InstagramPost.new(instagram_post).to_hash
      new_timeline << instagram_post_hash if instagram_post_hash.present?
    end

    facebook_timeline.each do |facebook_post|
      facebook_post_hash = FacebookPost.new(facebook_post).to_hash
      new_timeline << facebook_post_hash if facebook_post_hash.present?
    end

    new_timeline.sort_by { |x| x["created_time"] }.reverse
  end

end