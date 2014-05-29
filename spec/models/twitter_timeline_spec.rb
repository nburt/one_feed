require 'spec_helper'

describe TwitterTimeline do

  before do
    @user = User.create!(:email => 'nate@example.com', :password => 'password')
    @twitter_token = Token.create!(:provider => 'twitter', :uid => '23487234987234', :user_id => @user.id, :access_token => 'mock_token', :access_token_secret => 'secret_token')
  end

  describe "getting the timeline" do

    it 'can get the twitter timeline with the 20 most recent posts' do
      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=5').
        to_return(body: File.read('./spec/support/twitter_timeline.json'))

      twitter_timeline = TwitterTimeline.new(@user)
      expect(twitter_timeline.posts[0].text).to eq 'Gillmor Gang Live  05.02.14 http://t.co/WmzFBbPKUr by @stevegillmor'
      expect(twitter_timeline.posts[19].text).to eq 'At the dentist with the left lower quadrant of my face numb. Good thing I had a big breakfast.'
    end

  end

end