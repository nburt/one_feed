require 'spec_helper'

describe Feed do

  describe "#unauthed_accounts" do

    let(:user) { User.create!(:email => 'nate@example.com', :password => 'password') }

    before do
      stub_request(:post, 'https://api.twitter.com/oauth2/token')

      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json').
        to_return(status: 401)

      stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=').
        to_return(status: 400)

      twitter_token = Token.create!(:provider => 'twitter', :uid => '1237981238', :user_id => user.id, :access_token => nil, :access_token_secret => nil)
      instagram_token = Token.create!(:provider => 'instagram', :uid => '234234876', :user_id => user.id, :access_token => nil)
      mock_auth_hash
      twitter_token.validate_token!
      instagram_token.validate_token!

    end

    it 'will return a list of unauthed accounts' do
      feed = Feed.new(user)
      expect(feed.unauthed_accounts.map { |account| account.provider }).to eq ['instagram', 'twitter']
    end

  end

end