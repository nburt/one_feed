require 'spec_helper'

describe Cache::FacebookApi do
  it 'can get a users facebook timeline' do
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook/facebook_timeline.json'))
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'facebook', uid: '23948734', access_token: 'mock_token', access_token_secret: 'mock_secret_token', user_id: user.id)
    access_token = user.tokens.find_by(provider: 'facebook').access_token
    response = Cache::FacebookApi.get_timeline(access_token)
    expect(response.code).to eq 200
    expect(JSON.parse(response.body)["data"][0]["id"]).to eq '10202029985566360_10202029328989946'
  end
end