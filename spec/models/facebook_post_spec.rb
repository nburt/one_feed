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
                                            :id => "10204017311853547",
                                            :link_to_profile => "https://www.facebook.com/app_scoped_user_id/10204017311853547",
                                            :name => "Nick Anderson",
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
                                            },
                                            {
                                              :name => "Minal Shah",
                                              :link_to_profile => "https://www.facebook.com/app_scoped_user_id/2686395522487"
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

end