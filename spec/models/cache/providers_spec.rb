require 'spec_helper'

describe Cache::Providers do
  it 'can handle unauthorized responses from instagram' do
    body = {
      "meta" => {
        "error_type" => "OAuthParameterException",
        "code" => 400,
        "error_message" => "The access_token provided is invalid."
      }
    }.to_json

    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(status: 401, body: body)
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'instagram', uid: '23948734', access_token: 'mock_token', user_id: user.id)
    Cache::Providers.fetch_and_save_timelines(user)
    post = Post.last
    expect(post.post_array.length).to eq 1
    expect(post.post_array.first['provider']).to eq 'instagram'
    expect(post.post_array.first['body']).to eq body
    expect(post.post_array.first['code']).to eq 401
  end

  it 'can handle unauthorized responses from facebook' do
    body = {
      "error" => {
        "message" => "Invalid OAuth access token.",
        "type" => "OAuthException",
        "code" => 190
      }
    }.to_json
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(status: 190, body: body)
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'facebook', uid: '23948734', access_token: 'mock_token', access_token_secret: 'mock_secret_token', user_id: user.id)
    Cache::Providers.fetch_and_save_timelines(user)
    post = Post.last
    expect(post.post_array.length).to eq 1
    expect(post.post_array.first['provider']).to eq 'facebook'
    expect(post.post_array.first['body']).to eq body
    expect(post.post_array.first['code']).to eq 190
    expect(post.post_array.first['profile_pictures']).to eq({})
  end

  it 'can handle unauthorized responses from twitter' do
    body = {
      "errors" => [
        {
          "message" => "Bad Authentication data",
          "code" => 215
        }
      ]
    }.to_json
    stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=5').
      to_return(status: 400, body: body)
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'twitter', uid: '23948734', access_token: 'mock_token', access_token_secret: 'mock_token', user_id: user.id)
    Cache::Providers.fetch_and_save_timelines(user)
    post = Post.last
    expect(post.post_array.length).to eq 1
    expect(post.post_array.first['provider']).to eq 'twitter'
    expect(post.post_array.first['body']).to eq body
    expect(post.post_array.first['code']).to eq 400
  end

  it 'can clear out posts for a user' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(body: File.read('./spec/support/instagram/instagram_timeline.json'))
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Post.create!(post_array: [], user_id: user.id)
    expect(Post.count).to eq 1
    Cache::Providers.clear_user_posts(user)
    expect(Post.count).to eq 0
  end

  it 'can create a post including facebook profile pictures' do
    response = {
      "data" => {
        "url" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/p50x50/10359166_10202087887622570_1663761395861545071_n.jpg",
        "is_silhouette" => false
      }
    }.to_json
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(status: 200, body: File.read('./spec/support/facebook/one_post_facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10201999791700227/picture?redirect=false').
      to_return(:body => response)
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'facebook', uid: '23948734', access_token: 'mock_token', access_token_secret: 'mock_secret_token', user_id: user.id)
    Cache::Providers.fetch_and_save_timelines(user)
    post = Post.last
    expect(post.post_array.first['profile_pictures']['10201999791700227']).to eq 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/p50x50/10359166_10202087887622570_1663761395861545071_n.jpg'
  end
end
