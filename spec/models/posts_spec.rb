require 'spec_helper'

describe Posts do

  let(:params) { {post: 'what%20up', twitter: 'true', facebook: 'true'} }
  let(:user) { create_user }

  it 'can begin the process of creating a twitter post' do
    stub_request(:post, 'https://api.twitter.com/1.1/statuses/update.json').
      to_return(:status => 200, :body => File.read('./spec/support/twitter/twitter_post_response.json'))

    Token.create!(provider: 'twitter', uid: '132497', access_token: '123498', access_token_secret: '234513', user_id: user.id)
    posts = Posts.new(params, user)
    expect(posts.twitter).to eq Twitter::Tweet.new(id: 476136754127585280)
  end

  it 'can begin the process of creating a facebook post' do
    json = <<-JSON
{
  "id": "10201957829522504_10202145730539912"
}
    JSON

    stub_request(:post, 'https://graph.facebook.com/v2.0/me/feed?access_token=123498&message=what%20up').
      to_return(:status => 200, :body => json)
    stub_request(:get, 'https://graph.facebook.com/v2.0/10201957829522504_10202145730539912?access_token=123498').
      to_return(:status => 200, :body => File.read('./spec/support/models/posts/facebook_post.json'))
    stub_request(:get, 'https://graph.facebook.com/1396087480675877/picture?redirect=false').
      to_return(:status => 200, :body => File.read('./spec/support/models/posts/facebook_profile_picture.json'))
    Token.create!(provider: 'facebook', uid: '132497', access_token: '123498', access_token_secret: '234513', user_id: user.id)
    posts = Posts.new(params, user)
    expect(posts.facebook).to eq(
                                {
                                  "id" => "1396087480675877_1426819650935993",
                                  "from" => {
                                    "id" => "1396087480675877",
                                    "name" => "Tom Amhbciaegaeb Lauescu"
                                  },
                                  "message" => "what up",
                                  "actions" => [
                                    {"name" => "Comment",
                                     "link" => "https://www.facebook.com/100008239157152/posts/1426819650935993"
                                    },
                                    {"name" => "Like",
                                     "link" => "https://www.facebook.com/100008239157152/posts/1426819650935993"}],
                                  "privacy" => {
                                    "description" => "Your friends",
                                    "value" => "ALL_FRIENDS",
                                    "friends" => "",
                                    "networks" => "",
                                    "allow" => "",
                                    "deny" => ""},
                                  "type" => "status",
                                  "status_type" => "mobile_status_update",
                                  "application" => {
                                    "name" => "OneFeed Staging - local dev",
                                    "namespace" => "onefeedstagingtest",
                                    "id" => "661587723906295"},
                                  "created_time" => "2014-06-14T20:01:20+0000",
                                  "updated_time" => "2014-06-14T20:01:20+0000",
                                  :profile_picture_url => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/c5.0.50.50/p50x50/10298929_1426091331008825_4981210231336248758_s.jpg"
                                }
                              )
  end

  it 'can tell if a users account is authorized or not' do
    stub_request(:post, 'https://graph.facebook.com/v2.0/me/feed?access_token=123498&message=what%20up').
      to_return(:status => 463)
    Token.create!(provider: 'facebook', uid: '132497', access_token: '123498', access_token_secret: '234513', user_id: user.id)
    posts = Posts.new(params, user)
    begin
      posts.facebook
    rescue Facebook::Unauthorized
      expect(posts.unauthed_accounts).to eq ['Facebook']
    end
  end

end