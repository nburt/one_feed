require 'spec_helper'

describe FacebookPost do

  let(:posts) { Oj.load(File.read("./spec/support/facebook/facebook_post_creator_data.json")) }

  it 'should be able to process wall_posts' do
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

end