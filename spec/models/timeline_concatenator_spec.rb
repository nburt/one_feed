require 'spec_helper'

describe TimelineConcatenator do

  let(:twitter_data) { Oj.load(File.read("./spec/support/twitter_data_test.json")) }
  let(:instagram_data) { Oj.load(File.read("./spec/support/instagram_data_test.json")) }
  let(:facebook_data) { Oj.load(File.read("./spec/support/facebook_data_test.json")) }

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

    stub_request(:get, "https://graph.facebook.com/10202055803224824/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_40.json"))

    stub_request(:get, "https://graph.facebook.com/10201747824447839/picture?redirect=false").
      to_return(:body => File.read("./spec/support/facebook/picture_response_41.json"))

    timeline_concatenator = TimelineConcatenator.new
    result = timeline_concatenator.merge(twitter_data, instagram_data, facebook_data)
    expect(result).to eq [
                           {
                             :provider => "instagram",
                             :profile_picture => "http://images.ak.instagram.com/profiles/profile_221532163_75sq_1359427219.jpg",
                             :username => "j_burger8",
                             :user_url => "http://www.instagram.com/j_burger8",
                             :created_time => "2014-05-25 14:35:03 -0600",
                             :low_resolution_image_url => "http://scontent-b.cdninstagram.com/hphotos-prn/t51.2885-15/925856_1424901207774193_118091714_a.jpg",
                             :link_to_post => "http://instagram.com/p/obvPRPIdNp/",
                             :comments_count => 2,
                             :comments => [
                               {
                                 :created_time => "1401054214",
                                 :text => "Hahaa!!",
                                 :from => {
                                   :username => "yarrrisayin",
                                   :profile_picture => "http://images.ak.instagram.com/profiles/profile_14685800_75sq_1329985415.jpg",
                                   :id => "14685800",
                                   :full_name => "Adrian Pougiales"
                                 },
                                 :id => "728418008298541346"
                               },
                               {
                                 :created_time => "1401057296",
                                 :text => "Hell yeah burger!",
                                 :from => {
                                   :username => "tedmundoo",
                                   :profile_picture => "http://images.ak.instagram.com/profiles/profile_291016568_75sq_1395757808.jpg",
                                   :id => "291016568",
                                   :full_name => "Teddy L."
                                 },
                                 :id => "728443859664753434"
                               }
                             ],
                             :likes_count => 28,
                             :video => "http://scontent-a.cdninstagram.com/hphotos-frc/t50.2886-16/10419084_715655678498694_1036079256_n.mp4",
                             :type => "video",
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 17:59:03 -0600",
                             :from => {
                               :name => "Nicole Santilli",
                               :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10202055803224824",
                               :id => "10202055803224824",
                             },
                             :to => {
                               :name => "Caroline Pappas",
                               :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10201747824447839",
                               :id => "10201747824447839",
                             },
                             :image => {
                               :original_sized_image => "https://fbexternal-a.akamaihd.net/safe_image.php?d=AQBk0iUVbqDsEqSt&w=154&h=154&url=http%3A%2F%2Fcdn1.vox-cdn.com%2Fuploads%2Fchorus_image%2Fimage%2F33181045%2Fvlcsnap-2014-05-18-00h29m44s29.0_cinema_1200.0.png"
                             },
                             :message => "THIS. Caroline Pappas\n\nhttp://www.theverge.com/2014/5/18/5727788/snl-digital-shorts-return-with-davvincii-to-skewer-edm-and-overpaid-djs",
                             :message_tags => {
                               6 => [
                                 {
                                   :name => "Caroline Pappas",
                                   :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10201747824447839",
                                 }
                               ]
                             },
                             :article_name => "SNL Digital Shorts return with 'Davvincii' to skewer EDM and overpaid DJs",
                             :article_link => "http://www.theverge.com/2014/5/18/5727788/snl-digital-shorts-return-with-davvincii-to-skewer-edm-and-overpaid-djs",
                             :description => "SNL's Digital Shorts had been in cold storage since creators Andy Samberg, Jorma Taccone, and Akiva Schaffer left the show several years ago to pursue careers outside of 30 Rock. Luckily, the trio...",
                             :caption_text => "www.theverge.com",
                             :likes_count => 1,
                             :comments_count => 0,
                             :link_to_post => "https://www.facebook.com/1479060173/posts/10202136264676310",
                             :type => "link",
                             :status_type => "shared_story",
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 17:47:10 -0600",
                             :from => {
                               :name => "Ben Entenza Quam",
                               :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10203694030092980",
                               :id => "10203694030092980",
                             },
                             :image => {
                               :original_sized_image => "https://fbcdn-photos-b-a.akamaihd.net/hphotos-ak-prn2/t1.0-0/10390958_10203693748445939_321853996747520377_o.jpg",
                             },
                             :article_link => "https://www.facebook.com/photo.php?fbid=10203693748445939&set=at.10203693740605743.1073741827.1284300083.1284300078&type=1&relevant_count=1",
                             :description => "First photo with the new phone",
                             :story => "Ben Entenza Quam was tagged in Will Quam's photo.",
                             :likes_count => 2,
                             :comments_count => 0,
                             :story_tags => [
                               {
                                 :name => "Ben Entenza Quam",
                                 :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10203694030092980",
                               },
                               {
                                 :name => "Will Quam",
                                 :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10203694030132981",
                               }
                             ],
                             :application_name => "Photos",
                             :link_to_post => "https://www.facebook.com/1284300078/posts/10203693777206658",
                             :type => "photo",
                             :status_type => "tagged_in_photo",
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 17:24:46 -0600",
                             :from => {
                               :name => "Sophie Bober",
                               :link_to_profile => "https://www.facebook.com/app_scoped_user_id/2497151503215",
                               :id => "2497151503215",
                             },
                             :image => {
                               :original_sized_image => "https://fbcdn-photos-h-a.akamaihd.net/hphotos-ak-ash4/t1.0-0/10360683_10152122444571009_588035940768276969_o.jpg",
                             },
                             :article_link => "https://www.facebook.com/photo.php?fbid=10152122444571009&set=at.10151645143771009.1073741828.739431008.1085670496&type=1&relevant_count=5",
                             :story => "Sophie Bober was tagged in Haylee Moyser's photos.",
                             :likes_count => 0,
                             :comments_count => 0,
                             :story_tags => [
                               {
                                 :name => "Sophie Bober",
                                 :link_to_profile => "https://www.facebook.com/app_scoped_user_id/2497151503215",
                               },
                               {
                                 :name => "Haylee Moyser",
                                 :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10152122560306009",
                               }
                             ],
                             :application_name => "Photos",
                             :type => "photo",
                             :status_type => "tagged_in_photo",
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 15:49:57 -0600",
                             :from => {
                               :name => "Alexandra Leigh",
                               :link_to_profile => "https://www.facebook.com/app_scoped_user_id/2667146361270",
                               :id => "2667146361270",
                             },
                             :image => {
                               :original_sized_image => "https://fbcdn-photos-h-a.akamaihd.net/hphotos-ak-frc1/t1.0-0/10246610_2666936716029_2211264266589992336_o.jpg",
                             },
                             :message => "Sunday dinner with this girl and her wonderful family!  So full.",
                             :article_link => "https://www.facebook.com/photo.php?fbid=2666936716029&set=a.1782994258020.2048345.1334370453&type=1&relevant_count=1",
                             :likes_count => 0,
                             :comments_count => 0,
                             :application_name => "Instagram",
                             :link_to_post => "https://www.facebook.com/1334370453/posts/2666936676028",
                             :type => "photo",
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 15:41:10 -0600",
                             :from => {
                               :name => "Michael Wolff",
                               :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10204036212008354",
                               :id => "10204036212008354",
                             },
                             :image => {
                               :original_sized_image => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash3/t1.0-1/c8.7.95.95/p111x111/1174568_562847380417292_887241655_a.jpg",
                             },
                             :article_link => "https://www.facebook.com/EverythingMixed?ref=stream",
                             :story => "Michael Wolff likes Everything Mixed.",
                             :likes_count => 0,
                             :comments_count => 0,
                             :story_tags => [
                               {
                                 :name => "Michael Wolff",
                                 :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10204036212008354",
                               },
                               {
                                 :name => "Everything Mixed",
                                 :link_to_profile => "https://www.facebook.com/app_scoped_user_id/174710875897613",
                               }
                             ],
                             :application_name => "Pages",
                             :link_to_post => "https://www.facebook.com/1315516462/posts/10204131310305752",
                             :type => "link",
                           },
                           {
                             :provider => "facebook",
                             :created_time => "2014-05-18 15:29:54 -0600",
                             :from => {
                               :name => "Tom Cantwell",
                               :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10202029985566360",
                               :id => "10202029985566360",
                             },
                             :message => "Any good food in San Fran?",
                             :likes_count => 1,
                             :comments_count => 2,
                             :application_name => "Facebook for iPhone",
                             :link_to_post => "https://www.facebook.com/1087890173/posts/10202029328989946",
                             :type => "status",
                             :status_type => "mobile_status_update",
                             :shares_count => 1,
                           },
                           {
                             :provider => "instagram",
                             :profile_picture => "http://instagram.com",
                             :username => "Burt",
                             :user_url => "http://www.instagram.com/Burt",
                             :created_time => "2008-05-03 13:09:46 -0600",
                             :low_resolution_image_url => "http://instagram.com",
                             :caption_text => "sweet caption",
                             :link_to_post => "http://instagram.com",
                             :comments_count => 2,
                             :comments => [
                               {
                                 :created_time => nil,
                                 :text => "a comment",
                                 :from => {
                                   :username => "lujan",
                                   :profile_picture => "http://instagram.com",
                                   :id => nil,
                                   :full_name => nil,
                                 },
                                 :id => nil,
                               },
                               {
                                 :created_time => nil,
                                 :text => "another comment",
                                 :from => {
                                   :username => "burt",
                                   :profile_picture => "http://instagram.com",
                                   :id => nil,
                                   :full_name => nil,
                                 },
                                 :id => nil,
                               }
                             ],
                             :likes_count => 1,
                             :type => "photo"
                           },
                           {
                             :provider => "twitter",
                             :profile_picture => "http://twitter.com",
                             :user_name => "Nate",
                             :user_url => "https://twitter.com/nate",
                             :screen_name => "nate",
                             :created_time => "2007-03-07 18:27:09 -0700",
                             :tweet_text => "some tweet",
                             :retweet_count => 1,
                             :favorite_count => 1,
                             :link_to_tweet => "https://twitter.com/nate/status/1234",
                           },
                           {
                             :provider => "twitter",
                             :profile_picture => "http://twitter.com",
                             :user_name => "Burt",
                             :user_url => "https://twitter.com/burt",
                             :screen_name => "burt",
                             :created_time => "2007-03-06 18:27:09 -0700",
                             :tweet_text => "some tweet",
                             :retweet_count => 1,
                             :favorite_count => 1,
                             :link_to_tweet => "https://twitter.com/burt/status/1234",
                             :tweet_image => "http://twitter.com",
                           },
                           {
                             :provider => "instagram",
                             :profile_picture => "http://instagram.com",
                             :username => "Nate",
                             :user_url => "http://www.instagram.com/Nate",
                             :created_time => "2004-11-07 08:36:26 -0700",
                             :low_resolution_image_url => "http://instagram.com",
                             :caption_text => "sweet caption",
                             :link_to_post => "http://instagram.com",
                             :comments_count => 2,
                             :comments => [
                               {
                                 :created_time => nil,
                                 :text => "a comment",
                                 :from => {
                                   :username => "burt",
                                   :profile_picture => "http://instagram.com",
                                   :id => nil,
                                   :full_name => nil,
                                 },
                                 :id => nil,
                               },
                               {
                                 :created_time => nil,
                                 :text => "another comment",
                                 :from => {
                                   :username => "lujan",
                                   :profile_picture => "http://instagram.com",
                                   :id => nil,
                                   :full_name => nil,
                                 },
                                 :id => nil,
                               },
                             ],
                             :likes_count => 1,
                             :type => "photo",
                           }
                         ]
  end

end