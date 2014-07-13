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
    expect(post.post_array.first['provider']).to eq 'instagram'
    expect(post.post_array.first['body']).to eq body
    expect(post.post_array.first['status']).to eq 401
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
    expect(post.post_array[1]['provider']).to eq 'facebook'
    expect(post.post_array[1]['body']).to eq body
    expect(post.post_array[1]['status']).to eq 190
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
    expect(post.post_array[2]['provider']).to eq 'twitter'
    expect(post.post_array[2]['body']).to eq body
    expect(post.post_array[2]['status']).to eq 400
  end

  it 'can clear out posts for a user' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(body: File.read(File.expand_path('./spec/support/instagram/instagram_timeline.json')))
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Post.create!(post_array: [], user_id: user.id)
    expect(Post.count).to eq 1
    Cache::Providers.clear_user_posts(user)
    expect(Post.count).to eq 0
  end
end
