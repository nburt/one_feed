require 'spec_helper'

describe TimelineConcatenator do

  let(:twitter_data) { JSON.parse(File.read("./spec/support/twitter_data_test.json")) }
  let(:instagram_data) { JSON.parse(File.read("./spec/support/instagram_data_test.json")) }

  it 'should merge timelines, rename time keys to all be created_time, and sort them by date' do
    timeline_concatenator = TimelineConcatenator.new
    expect(timeline_concatenator.merge(twitter_data, instagram_data)).to eq [
                                                                              {
                                                                                "provider" => "instagram",
                                                                                "profile_picture" => "http://instagram.com",
                                                                                "username" => "Burt",
                                                                                "user_url" => "http://www.instagram.com/Burt",
                                                                                "created_time" => "2008-05-03 13:09:46 -0600",
                                                                                "low_resolution_image_url" => "http://instagram.com",
                                                                                "caption_text" => "sweet caption",
                                                                                "link_to_post" => "http://instagram.com",
                                                                                "comments_count" => "2",
                                                                                "comments" => [
                                                                                  {
                                                                                    "text" => "a comment",
                                                                                    "from" => {
                                                                                      "username" => "lujan",
                                                                                      "profile_picture" => "http://instagram.com"
                                                                                    }
                                                                                  },
                                                                                  {
                                                                                    "text" => "another comment",
                                                                                    "from" => {
                                                                                      "username" => "burt",
                                                                                      "profile_picture" => "http://instagram.com"
                                                                                    }
                                                                                  }
                                                                                ],
                                                                                "likes_count" => "1",
                                                                              },
                                                                              {
                                                                                "provider" => "twitter",
                                                                                "profile_picture" => "http://twitter.com",
                                                                                "user_name" => "Nate",
                                                                                "user_url" => "http://twitter.com",
                                                                                "screen_name" => "nate",
                                                                                "created_time" => "2007-03-07 18:27:09 -0700",
                                                                                "tweet_text" => "some tweet",
                                                                                "retweet_count" => "1",
                                                                                "favorite_count" => "1",
                                                                                "link_to_tweet" => "https://twitter.com/nate/status/1234",
                                                                              },
                                                                              {
                                                                                "provider" => "twitter",
                                                                                "profile_picture" => "http://twitter.com",
                                                                                "user_name" => "Burt",
                                                                                "user_url" => "http://twitter.com",
                                                                                "screen_name" => "burt",
                                                                                "created_time" => "2007-03-06 18:27:09 -0700",
                                                                                "tweet_text" => "some tweet",
                                                                                "retweet_count" => "1",
                                                                                "favorite_count" => "1",
                                                                                "link_to_tweet" => "https://twitter.com/burt/status/1234",
                                                                              },
                                                                              {
                                                                                "provider" => "instagram",
                                                                                "profile_picture" => "http://instagram.com",
                                                                                "username" => "Nate",
                                                                                "user_url" => "http://www.instagram.com/Nate",
                                                                                "created_time" => "2004-11-07 08:36:26 -0700",
                                                                                "low_resolution_image_url" => "http://instagram.com",
                                                                                "caption_text" => "sweet caption",
                                                                                "link_to_post" => "http://instagram.com",
                                                                                "comments_count" => "2",
                                                                                "comments" => [
                                                                                  {
                                                                                    "text" => "a comment",
                                                                                    "from" => {
                                                                                      "username" => "burt",
                                                                                      "profile_picture" => "http://instagram.com"
                                                                                    }
                                                                                  },
                                                                                  {
                                                                                    "text" => "another comment",
                                                                                    "from" => {
                                                                                      "username" => "lujan",
                                                                                      "profile_picture" => "http://instagram.com"
                                                                                    }
                                                                                  }
                                                                                ],
                                                                                "likes_count" => "1",
                                                                              }
                                                                            ]
  end

end