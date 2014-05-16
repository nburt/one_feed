require 'spec_helper'

describe InstagramApi do

  it 'can get the instagram timeline for a given user' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token').
      to_return(body: File.read(File.expand_path('./spec/support/instagram_timeline.json')))
    instagram_api = InstagramApi.new('mock_token')
    timeline = instagram_api.get_timeline
    expect(timeline.posts[0]["caption"]["text"]).to eq 'The girls #pumped #herewego'
  end

  it 'will return true if successful' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token').
      to_return(body: File.read(File.expand_path('./spec/support/instagram_timeline.json')))
    instagram_api = InstagramApi.new('mock_token')
    timeline = instagram_api.get_timeline
    expect(timeline.success?).to eq true
  end

  it 'will return false if the users\'s token is no longer valid' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token').
      to_return(status: 400)
    instagram_api = InstagramApi.new('mock_token')
    timeline = instagram_api.get_timeline
    expect(timeline.posts).to eq []
  end

end