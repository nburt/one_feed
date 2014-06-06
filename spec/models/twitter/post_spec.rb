require 'spec_helper'

describe Twitter::Post do
  it 'can create instances from Twitter::Tweet objects' do
    twitter_tweet = Twitter::Tweet.new(id: 1, created_at: "2014-05-10 17:59:03 -0600")

    twitter_post = Twitter::Post.from(twitter_tweet)

    expect(twitter_post.created_time).to eq Time.parse("2014-05-10 17:59:03 -0600")
  end

  it 'can get the provider' do
    twitter_tweet = Twitter::Tweet.new(id: 1, created_at: "2014-05-10 17:59:03 -0600")

    twitter_post = Twitter::Post.from(twitter_tweet)

    expect(twitter_post.provider).to eq("twitter")
  end

end