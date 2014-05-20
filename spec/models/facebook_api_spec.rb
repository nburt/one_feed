require 'spec_helper'

describe FacebookApi do

  it 'can get the instagram timeline for a given user' do
    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token').
      to_return(body: File.read(File.expand_path('./spec/support/facebook_timeline.json')))
    facebook_api = FacebookApi.new('mock_token')
    timeline = facebook_api.get_timeline
    expect(timeline.posts[0]["id"]).to eq '10203694030092980_10203693777206658'
  end

  it 'will return true if successful' do
    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token').
      to_return(body: File.read(File.expand_path('./spec/support/facebook_timeline.json')))
    facebook_api = FacebookApi.new('mock_token')
    timeline = facebook_api.get_timeline
    expect(timeline.success?).to eq true
  end

  it 'will return an empty array if the users\'s token is no longer valid' do
    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token').
      to_return(status: 463)
    facebook_api = FacebookApi.new('mock_token')
    timeline = facebook_api.get_timeline
    expect(timeline.posts).to eq []
  end

  it 'will return a user\'s profile picture' do
    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))

    expect(FacebookApi.user_profile_picture('10203694030092980')).to eq 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg'
  end

end