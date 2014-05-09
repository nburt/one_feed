require 'spec_helper'

describe Provider do

  describe 'omniauth login' do

    let (:provider) {Provider.new(:provider => 'twitter', :uid => '2343794081')}

    it 'can create a user with omniauth' do
      expect(provider).to be_valid
    end

    it 'cannot create a user without a provider' do
      provider.provider = nil
      expect(provider).to_not be_valid
    end

    it 'cannot create a user without a uid' do
      provider.uid = nil
      expect(provider).to_not be_valid
    end

  end

  describe 'rendering Tweets in the feed' do
    it 'can configure TWitter::REST:Client' do
      provider = Provider.new
      client = provider.configure_twitter(ENV['TWITTER_ACCESS_TOKEN'], ENV['TWITTER_ACCESS_TOKEN_SECRET'])
      expect(client.access_token).to eq ENV['TWITTER_ACCESS_TOKEN']
      expect(client.access_token_secret).to eq ENV['TWITTER_ACCESS_SECRET']
    end
  end

end