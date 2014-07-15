require 'spec_helper'

describe Twitter::Timeline do

  before do
    @user = create_user
    @twitter_token = Token.create!(:provider => 'twitter', :uid => '23487234987234', :user_id => @user.id, :access_token => 'mock_token', :access_token_secret => 'secret_token')
  end

  describe "getting the timeline" do

    it 'can get the twitter timeline with the 5 most recent posts' do
      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json?count=5').
        to_return(body: File.read('./spec/support/twitter/twitter_timeline.json'))

      twitter_timeline = Twitter::Timeline.new(@user)
      expect(twitter_timeline.posts[0].text).to eq 'Gillmor Gang Live  05.02.14 http://t.co/WmzFBbPKUr by @stevegillmor'
    end

  end

  describe "posting to the timeline" do

    it 'can create a tweet' do
      stub_request(:post, 'https://api.twitter.com/1.1/statuses/update.json').
        to_return(:status => 200, :body => File.read('./spec/support/twitter/twitter_post_response.json'))
      twitter_timeline = Twitter::Timeline.new(@user)
      expect(twitter_timeline.create_tweet("Maybe he'll finally find his keys. #peterfalk").text).to eq "Maybe he'll finally find his keys. #peterfalk"
    end

  end

end