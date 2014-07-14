require 'spec_helper'

describe Cache::FacebookApi do
  it 'can get a users facebook timeline' do
    response = {
      "data" => {
        "url" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/p50x50/10359166_10202087887622570_1663761395861545071_n.jpg",
        "is_silhouette" => false
      }
    }.to_json
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook/one_post_facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10201999791700227/picture?redirect=false').
      to_return(:body => response)
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'facebook', uid: '23948734', access_token: 'mock_token', access_token_secret: 'mock_secret_token', user_id: user.id)
    access_token = user.tokens.find_by(provider: 'facebook').access_token
    cache_facebook_api = Cache::FacebookApi.new(access_token)
    cache_facebook_api.get_timeline
    expect(cache_facebook_api.timeline_response.code).to eq 200
    expect(JSON.parse(cache_facebook_api.timeline_response.body)["data"][0]["id"]).to eq '10201999791700227_10202101615725764'
  end

  it 'can get profile pictures for a timeline' do
    response = {
      "data" => {
        "url" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/p50x50/10359166_10202087887622570_1663761395861545071_n.jpg",
        "is_silhouette" => false
      }
    }.to_json

    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook/one_post_facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10201999791700227/picture?redirect=false').
      to_return(:body => response)
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'facebook', uid: '23948734', access_token: 'mock_token', access_token_secret: 'mock_secret_token', user_id: user.id)
    access_token = user.tokens.find_by(provider: 'facebook').access_token
    cache_facebook_api = Cache::FacebookApi.new(access_token)
    cache_facebook_api.get_timeline
    expect(cache_facebook_api.profile_pictures['10201999791700227']).to eq 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/p50x50/10359166_10202087887622570_1663761395861545071_n.jpg'
  end
end