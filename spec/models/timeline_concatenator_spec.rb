require 'spec_helper'

describe TimelineConcatenator do

  let(:twitter_data) { JSON.parse(File.read("./spec/support/twitter_data_test.json")) }
  let(:instagram_data) { JSON.parse(File.read("./spec/support/instagram_data_test.json")) }
  let(:facebook_data) { JSON.parse(File.read("./spec/support/facebook_data_test.json")) }

  it 'should merge timelines, rename time keys to all be created_time, and sort them by date' do
    stub_request(:get, "https://graph.facebook.com/10203694030092980/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_1.json"))

    stub_request(:get, "https://graph.facebook.com/2497151503215/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_2.json"))

    stub_request(:get, "https://graph.facebook.com/2667146361270/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_3.json"))

    stub_request(:get, "https://graph.facebook.com/10204036212008354/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_4.json"))

    stub_request(:get, "https://graph.facebook.com/10202029985566360/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_5.json"))

    stub_request(:get, "https://graph.facebook.com/10152831000093574/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_6.json"))

    stub_request(:get, "https://graph.facebook.com/667644649949344/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_7.json"))

    timeline_concatenator = TimelineConcatenator.new
    result = timeline_concatenator.merge(twitter_data, instagram_data, facebook_data)
    expect(result).to eq [
                           {
                             "provider" => "facebook",
                             "created_time" => "2014-05-18 17:47:10 -0600",
                             "from" => {
                               "profile_picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg",
                               "name" => "Ben Entenza Quam",
                               "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/10203694030092980",
                             },
                             "image" => {
                               "original_sized_image" => "https://fbcdn-photos-b-a.akamaihd.net/hphotos-ak-prn2/t1.0-0/10390958_10203693748445939_321853996747520377_o.jpg",
                               "caption_text" => "First photo with the new phone",
                             },
                             "story" => "Ben Entenza Quam was tagged in Will Quam's photo.",
                             "likes_count" => 2,
                             "comments_count" => 0,
                             "story_tags" => {
                               "0" => [
                                 {
                                   "name" => "Ben Entenza Quam",
                                   "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/10203694030092980",
                                 },
                               ],
                               "31" => [
                                 {
                                   "name" => "Will Quam",
                                   "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/10203694030132981",
                                 }
                               ]
                             },
                             "application_name" => "Photos",
                             "link_to_post" => "https://www.facebook.com/photo.php?fbid=10203693748445939&set=at.10203693740605743.1073741827.1284300083.1284300078&type=1&relevant_count=1",
                             "status_type" => "tagged_in_photo",
                           },
                           {
                             "provider" => "facebook",
                             "created_time" => "2014-05-18 17:24:46 -0600",
                             "from" => {
                               "profile_picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c0.0.50.50/p50x50/10342915_2482379853933_2019125027865883654_t.jpg",
                               "name" => "Sophie Bober",
                               "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/2497151503215",
                             },
                             "image" => {
                               "original_sized_image" => "https://fbcdn-photos-h-a.akamaihd.net/hphotos-ak-ash4/t1.0-0/10360683_10152122444571009_588035940768276969_o.jpg",
                             },
                             "story" => "Sophie Bober was tagged in Haylee Moyser's photos.",
                             "likes_count" => 0,
                             "comments_count" => 0,
                             "story_tags" => {
                               "0" => [
                                 {
                                   "name" => "Sophie Bober",
                                   "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/2497151503215",
                                 },
                               ],
                               "27" => [
                                 {
                                   "name" => "Haylee Moyser",
                                   "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/10152122560306009",
                                 }
                               ]
                             },
                             "application_name" => "Photos",
                             "link_to_post" => "https://www.facebook.com/photo.php?fbid=10152122444571009&set=at.10151645143771009.1073741828.739431008.1085670496&type=1&relevant_count=5",
                             "status_type" => "tagged_in_photo",
                           },
                           {
                             "provider" => "facebook",
                             "created_time" => "2014-05-18 15:49:57 -0600",
                             "from" => {
                               "profile_picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-frc3/t1.0-1/p50x50/10001515_2625709645378_611197295_t.jpg",
                               "name" => "Alexandra Leigh",
                               "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/2667146361270",
                             },
                             "image" => {
                               "original_sized_image" => "https://fbcdn-photos-h-a.akamaihd.net/hphotos-ak-frc1/t1.0-0/10246610_2666936716029_2211264266589992336_o.jpg",
                             },
                             "message" => "Sunday dinner with this girl and her wonderful family!  So full.",
                             "likes_count" => 0,
                             "comments_count" => 0,
                             "application_name" => "Instagram",
                             "link_to_post" => "https://www.facebook.com/photo.php?fbid=2666936716029&set=a.1782994258020.2048345.1334370453&type=1&relevant_count=1",
                           },
                           {
                             "provider" => "facebook",
                             "created_time" => "2014-05-18 15:41:10 -0600",
                             "from" => {
                               "profile_picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn2/t1.0-1/c9.9.112.112/s50x50/5342_10201448883526759_1732651731_s.jpg",
                               "name" => "Michael Wolff",
                               "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/10204036212008354",
                             },
                             "image" => {
                               "original_sized_image" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash3/t1.0-1/c8.7.95.95/p111x111/1174568_562847380417292_887241655_a.jpg",
                             },
                             "story" => "Michael Wolff likes Everything Mixed.",
                             "likes_count" => 0,
                             "comments_count" => 0,
                             "story_tags" => {
                               "0" => [
                                 {
                                   "name" => "Michael Wolff",
                                   "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/10204036212008354",
                                 },
                               ],
                               "20" => [
                                 {
                                   "name" => "Everything Mixed",
                                   "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/174710875897613",
                                 }
                               ]
                             },
                             "application_name" => "Pages",
                             "link_to_post" => "https://www.facebook.com/EverythingMixed?ref=stream",
                           },
                           {
                             "provider" => "facebook",
                             "created_time" => "2014-05-18 15:29:54 -0600",
                             "from" => {
                               "profile_picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash3/t1.0-1/c9.9.112.112/s50x50/562835_4671351136921_529669596_s.jpg",
                               "name" => "Tom Cantwell",
                               "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/10202029985566360",
                             },
                             "message" => "Any good food in San Fran?",
                             "likes_count" => 1,
                             "comments_count" => 2,
                             "comments" => [
                               {
                                 "from" => {
                                   "name" => "Jon Turner",
                                   "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/10152831000093574",
                                   "profile_picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn2/t1.0-1/c2.0.50.50/p50x50/10367723_10152814518023574_7761080589494120194_s.jpg",
                                 },
                                 "message" => "China town",
                                 "created_time" => "2014-05-18 15:58:01 -0600",
                                 "like_count" => 0,
                               },
                               {
                                 "from" => {
                                   "name" => "Wayne Roxann Blackmer",
                                   "link_to_profile" => "https://www.facebook.com/app_scoped_user_id/667644649949344",
                                   "profile_picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash3/t1.0-1/c9.9.112.112/s50x50/553464_428457843868027_1363898235_s.jpg",
                                 },
                                 "message" => "Rice a roni ...lmao",
                                 "created_time" => "2014-05-18 15:58:59 -0600",
                                 "like_count" => 2,
                               }
                             ],
                             "application_name" => "Facebook for iPhone",
                             "status_type" => "mobile_status_update",
                             "shares_count" => 1,
                           },
                           {
                             "provider" => "instagram",
                             "profile_picture" => "http://instagram.com",
                             "username" => "Burt",
                             "user_url" => "http://www.instagram.com/Burt",
                             "created_time" => "2008-05-03 13:09:46 -0600",
                             "low_resolution_image_url" => "http://instagram.com",
                             "caption_text" => "sweet caption",
                             "link_to_post" => "http://instagram.com",
                             "comments_count" => 2,
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
                             "likes_count" => 1,
                           },
                           {
                             "provider" => "twitter",
                             "profile_picture" => "http://twitter.com",
                             "user_name" => "Nate",
                             "user_url" => "http://twitter.com",
                             "screen_name" => "nate",
                             "created_time" => "2007-03-07 18:27:09 -0700",
                             "tweet_text" => "some tweet",
                             "retweet_count" => 1,
                             "favorite_count" => 1,
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
                             "retweet_count" => 1,
                             "favorite_count" => 1,
                             "link_to_tweet" => "https://twitter.com/burt/status/1234",
                             "tweet_image" => "http://twitter.com",
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
                             "comments_count" => 2,
                             "comments" => [
                               {
                                 "text" => "a comment",
                                 "from" => {
                                   "username" => "burt",
                                   "profile_picture" => "http://instagram.com",
                                 }
                               },
                               {
                                 "text" => "another comment",
                                 "from" => {
                                   "username" => "lujan",
                                   "profile_picture" => "http://instagram.com",
                                 }
                               },
                             ],
                             "likes_count" => 1,
                           }
                         ]
  end

end