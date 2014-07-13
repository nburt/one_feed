require 'spec_helper'

describe Cache::TwitterApi do
  it 'can get a users twitter timeline' do
    stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=5').
      to_return(body: File.read('./spec/support/twitter/twitter_timeline.json'))
    user = User.create!(email: 'nate@example.com', password_digest: 'password', first_name: 'Nate', last_name: 'Burt')
    Token.create!(provider: 'twitter', uid: '23948734', access_token: 'mock_token', access_token_secret: 'mock_token', user_id: user.id)
    token = user.tokens.find_by(provider: 'twitter')
    response = Cache::TwitterApi.get_timeline(token)
    expect(response[0].text).to eq 'Gillmor Gang Live  05.02.14 http://t.co/WmzFBbPKUr by @stevegillmor'
  end
end