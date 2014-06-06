require 'spec_helper'

describe FacebookPost do

  let(:posts) { Oj.load(File.read("./spec/support/facebook/facebook_post_creator_data.json")) }

  it 'should be able to process photos' do
    facebook_post = FacebookPost.new(posts[0])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 14:21:57 -0600",
                                          :from => {
                                            :id => "10201999791700227",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10201999791700227",
                                            :name => "Laurie Laker",
                                          },
                                          :message => "Done and dusted with Dartmouth. I'm now apparently a Master of something. Who knew?! :)",
                                          :image => {
                                            :original_sized_image => "https://fbcdn-photos-e-a.akamaihd.net/hphotos-ak-xpf1/t1.0-0/10338223_10202101615765765_5555346887156788052_o.jpg",
                                          },
                                          :article_link => "https://www.facebook.com/photo.php?fbid=10202101615765765&set=a.3909267534002.135123.1348740063&type=1&relevant_count=1",
                                          :likes_count => 0,
                                          :comments_count => 0,
                                          :link_to_post => "https://www.facebook.com/1348740063/posts/10202101615725764",
                                          :type => "photo",
                                          :application_name => "Instagram"
                                        })

  end

  it 'should be able to process wall_post' do
    facebook_post = FacebookPost.new(posts[1])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 14:08:17 -0600",
                                          :from => {
                                            :id => "10201982999926302",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10201982999926302",
                                            :name => "Becca Thomas",
                                          },
                                          :to => {
                                            :name => "Nick Anderson",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10204017311853547",
                                            :id => "10204017311853547",
                                          },
                                          :message => "happy birthday my love!!!",
                                          :likes_count => 0,
                                          :comments_count => 0,
                                          :link_to_post => "https://www.facebook.com/1246050030/posts/10204149077427604",
                                          :type => "status",
                                          :status_type => "wall_post",
                                        })
  end

  it 'should be able to process mobile_status_update' do
    facebook_post = FacebookPost.new(posts[2])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 13:58:05 -0600",
                                          :from => {
                                            :id => "10152071074642001",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10152071074642001",
                                            :name => "Kai Ishino",
                                          },
                                          :message => "Lunch with the tax partner before my flight home... Networking never ends 😬",
                                          :likes_count => 0,
                                          :comments_count => 2,
                                          :link_to_post => "https://www.facebook.com/624517000/posts/10152103382247001",
                                          :type => "status",
                                          :status_type => "mobile_status_update",
                                          :application_name => "Facebook for iPhone"
                                        })
  end

  it 'should be able to process tagged_in_photo' do
    facebook_post = FacebookPost.new(posts[6])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 13:26:48 -0600",
                                          :from => {
                                            :id => "10153074975361029",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10153074975361029",
                                            :name => "Emmanuel Chan",
                                          },
                                          :story => "Emmanuel Chan was tagged in Minal Shah's photo.",
                                          :story_tags => [
                                            {
                                              :name => "Emmanuel Chan",
                                              :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10153074975361029",
                                              :type => "user",
                                            },
                                            {
                                              :name => "Minal Shah",
                                              :link_to_profile => "https://www.facebook.com/app_scoped_user_id/2686395522487",
                                              :type => "user",
                                            }
                                          ],
                                          :image => {
                                            :original_sized_image => "https://fbcdn-photos-d-a.akamaihd.net/hphotos-ak-xfp1/t1.0-0/10401435_2685884629715_1444031587313675951_o.jpg",
                                          },
                                          :article_link => "https://www.facebook.com/photo.php?fbid=2685884629715&set=at.2685874229455.1073741829.1334370399.630471028&type=1&relevant_count=1",
                                          :likes_count => 0,
                                          :comments_count => 0,
                                          :link_to_post => "https://www.facebook.com/630471028/posts/10153110032051029",
                                          :type => "photo",
                                          :status_type => "tagged_in_photo",
                                          :application_name => "Photos"
                                        })
  end

  it 'should be able to handle a cover photo update' do
    facebook_post = FacebookPost.new(posts[7])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 13:10:33 -0600",
                                          :from => {
                                            :id => "10154160680320506",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10154160680320506",
                                            :name => "Ryan Patterson",
                                          },
                                          :story => "Ryan Patterson updated his cover photo.",
                                          :story_tags => [
                                            {
                                              :name => "Ryan Patterson",
                                              :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10154160680320506",
                                              :type => "user",
                                            },
                                          ],
                                          :image => {
                                            :original_sized_image => "https://fbcdn-photos-b-a.akamaihd.net/hphotos-ak-xpf1/t1.0-0/10409408_10154203761035506_5648453343670474156_o.jpg",
                                          },
                                          :article_link => "https://www.facebook.com/photo.php?fbid=10154203761035506&set=a.10152044998885506.900006.794960505&type=1&relevant_count=1",
                                          :likes_count => 25,
                                          :comments_count => 0,
                                          :link_to_post => "https://www.facebook.com/794960505/posts/10154203761065506",
                                          :type => "photo",
                                        })
  end

  it 'should be able to handle mobile_status_update with to hash' do
    facebook_post = FacebookPost.new(posts[8])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 13:07:25 -0600",
                                          :from => {
                                            :id => "10202659107733578",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10202659107733578",
                                            :name => "Nathan Eberhart",
                                          },
                                          :to => {
                                            :id => "465165273626827",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/465165273626827",
                                            :name => "Dan Begun",
                                          },
                                          :message => "Checking out Dan's new stomping grounds!",
                                          :likes_count => 3,
                                          :comments_count => 0,
                                          :link_to_post => "https://www.facebook.com/1074600005/posts/10202750187450514",
                                          :type => "status",
                                          :status_type => "mobile_status_update",
                                          :application_name => "Facebook for Android"
                                        })
  end

  it 'should be able to handle shared_story posts' do
    facebook_post = FacebookPost.new(posts[9])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 12:19:31 -0600",
                                          :from => {
                                            :id => "10201958334335124",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10201958334335124",
                                            :name => "Noah Geupel"
                                          },
                                          :story => "Noah Geupel shared Judge Skelton Smith Architects's album: Townhouse Renovation.",
                                          :story_tags => [
                                            {
                                              :name => "Noah Geupel",
                                              :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10201958334335124",
                                              :type => "user",
                                            },
                                            {
                                              :name => "Judge Skelton Smith Architects",
                                              :type => "page",
                                            },
                                          ],
                                          :image => {
                                            :original_sized_image => "https://fbcdn-photos-d-a.akamaihd.net/hphotos-ak-xap1/t1.0-0/10420106_519726308131372_627341769406227038_o.jpg",
                                          },
                                          :article_link => "https://www.facebook.com/jssarch/photos/a.519711128132890.1073741827.193541854083154/519726308131372/?type=1",
                                          :likes_count => 0,
                                          :comments_count => 0,
                                          :link_to_post => "https://www.facebook.com/1087890285/posts/10202124720254668",
                                          :type => "photo",
                                          :status_type => "shared_story",
                                          :application_name => "Photos"
                                        })
  end

  it 'should be able to handle video posts' do
    facebook_post = FacebookPost.new(posts[10])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 11:58:48 -0600",
                                          :from => {
                                            :id => "10203121291807592",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10203121291807592",
                                            :name => "Anna Berghoff",
                                          },
                                          :to => {
                                            :id => "10202861369233516",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10202861369233516",
                                            :name => "Greg Siegel",
                                          },
                                          :message => "http://www.youtube.com/watch?v=6vopR3ys8Kw&feature=kp...next time we need to learn this dance before the concert. i bet chet would let us join him on stage that way :)",
                                          :video_link => "http://www.youtube.com/watch?v=6vopR3ys8Kw&feature=kp",
                                          :source => "http://www.youtube.com/v/6vopR3ys8Kw?autohide=1&version=3&autoplay=1",
                                          :video_name => "Flume & Chet Faker - Drop the Game [Official Music Video]",
                                          :video_description => "From Flume & Chet Faker's collaborative Lockjaw EP. Subscribe to our channel here: http://smarturl.it/FC_YouTube Get it on iTunes: http://smarturl.it/Lockjaw...",
                                          :link_to_post => "https://www.facebook.com/1065638934/posts/10203250828885938",
                                          :type => "video",
                                          :status_type => "shared_story"
                                        })
  end

  it 'should be handle link type posts' do
    facebook_post = FacebookPost.new(posts[11])
    expect(facebook_post.to_hash).to eq({
                                          :provider => "facebook",
                                          :created_time => "2014-06-05 11:28:04 -0600",
                                          :from => {
                                            :id => "10202052817617147",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10202052817617147",
                                            :name => "Mary Jennings Van Sant",
                                          },
                                          :to => {
                                            :id => "10202042605921861",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10202042605921861",
                                            :name => "Hannah Bogardus",
                                          },
                                          :message => "http://www.heathersdish.com/ad-free/3-minute-avocado-toast-with-hard-boiled-eggs/\n\nThis has your name ALL over it.  MISS AND LOVE YOU!!!",
                                          :image => {
                                            :original_sized_image => "https://fbexternal-a.akamaihd.net/safe_image.php?d=AQCrPO_2Sa06LdBQ&w=154&h=154&url=http%3A%2F%2Fwww.heathersdish.com%2Fwp-content%2Fuploads%2F2013%2F07%2Fblog-71.jpg",
                                          },
                                          :article_link => "http://www.heathersdish.com/ad-free/3-minute-avocado-toast-with-hard-boiled-eggs/",
                                          :article_name => "3-Minute Avocado Toast with Hard-Boiled Eggs | Heather's Dish",
                                          :article_caption => "www.heathersdish.com",
                                          :article_description => "This snack. I can't even come up with the words you guys - I have literally been having it every day for the past week and a half and there's no way I see",
                                          :link_to_post => "https://www.facebook.com/1087890261/posts/10202124559850658",
                                          :type => "link",
                                          :status_type => "shared_story"
                                        })
  end

end