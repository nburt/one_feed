require 'spec_helper'

describe Feed do

  describe "#unauthed_accounts" do

    let(:user) { User.create!(:first_name => 'Nate', :last_name => 'Burt', :email => 'nate@example.com', :password => 'password') }

    before do
      stub_request(:post, 'https://api.twitter.com/oauth2/token')

      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=5').
        to_return(status: 401)

      stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=&count=5').
        to_return(status: 400)

      stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=&limit=5').
        to_return(status: 463)

      Token.create!(:provider => 'twitter', :uid => '1237981238', :user_id => user.id, :access_token => nil, :access_token_secret => nil)
      Token.create!(:provider => 'instagram', :uid => '234234876', :user_id => user.id, :access_token => nil)
      Token.create!(:provider => 'facebook', :uid => '23487234987234', :user_id => user.id, :access_token => nil)
      mock_auth_hash
    end

    it 'will return a list of unauthed accounts' do
      feed = Feed.new(user, nil, nil, nil)
      feed.timeline
      expect(feed.unauthed_accounts).to eq ['twitter', 'instagram', 'facebook']
    end

  end

end