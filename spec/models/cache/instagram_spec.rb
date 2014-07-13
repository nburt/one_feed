require 'spec_helper'

describe Cache::InstagramApi do
  it 'can get a users instagram timeline' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(body: File.read(File.expand_path('./spec/support/instagram/instagram_timeline.json')))
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'instagram', uid: '23948734', access_token: 'mock_token', user_id: user.id)
    access_token = user.tokens.find_by(provider: 'instagram').access_token
    response = Cache::InstagramApi.get_timeline(access_token)
    expect(response.code).to eq 200
    expect(JSON.parse(response.body)["data"][0]["caption"]["text"]).to eq 'The girls #pumped #herewego'
  end
end