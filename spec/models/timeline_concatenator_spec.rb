require 'spec_helper'

describe TimelineConcatenator do

  it 'should sort them by date' do
    twitter_tweet1 = Twitter::Tweet.new(id: 1, created_at: "2014-05-10 17:59:03 -0600")
    twitter_tweet2 = Twitter::Tweet.new(id: 1, created_at: "2014-05-25 14:35:03 -0600")
    twitter_posts = [Twitter::Post.from(twitter_tweet1), Twitter::Post.new(twitter_tweet2)]
    instagram_posts = [Instagram::Post.new('created_time' => "1399842218")]
    facebook_posts = [Facebook::DefaultPost.new('created_time' => "2014-05-18T21:41:10+0000")]
    timeline_concatenator = TimelineConcatenator.new
    sorted_entries = timeline_concatenator.merge(twitter_posts, instagram_posts, facebook_posts)

    sorted_dates = sorted_entries.map{|entry|entry.created_time}

    expect(sorted_dates).to eq [Time.parse("2014-05-25 14:35:03 -0600"), Time.parse("2014-05-18T21:41:10+0000"), Time.at(1399842218), Time.parse("2014-05-10 17:59:03 -0600")]
  end

end