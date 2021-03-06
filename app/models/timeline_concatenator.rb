class TimelineConcatenator

  def merge(twitter_timeline, instagram_timeline, facebook_timeline)
    (twitter_timeline + instagram_timeline + facebook_timeline).sort_by { |post| post.created_time }.reverse
  end

end