require 'spec_helper'

describe FacebookApi do

  it 'can get the instagram timeline for a given user' do
    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))

    facebook_api = FacebookApi.new('mock_token', nil)
    facebook_timeline = facebook_api.timeline
    expect(facebook_api.posts[0]["id"]).to eq '10203694030092980_10203693777206658'
  end

  it 'will return true if successful' do
    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))

    facebook_api = FacebookApi.new('mock_token', nil)
    timeline = facebook_api.timeline
    expect(facebook_api.success?).to eq true
  end

  it 'will return an empty array if the users\'s token is no longer valid' do
    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token&limit=5').
      to_return(status: 463, body: File.read('./spec/support/facebook/invalid_oauth_token.json'))

    facebook_api = FacebookApi.new('mock_token', nil)
    timeline = facebook_api.timeline
    expect(facebook_api.posts).to eq []
  end

  it 'will return a user\'s profile picture' do
    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))

    facebook_api = FacebookApi.new('mock_token', nil)
    timeline = facebook_api.timeline
    expect(facebook_api.poster_recipient_profile_hash['10203694030092980']).to eq 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg'
  end

  it 'will return a commenter\'s profile picture' do
    stub_request(:get, 'https://graph.facebook.com/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))

    facebook_api = FacebookApi.new('mock_token', nil)
    timeline = facebook_api.timeline
    expect(facebook_api.commenter_profile_hash['10203694030092980']).to eq 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg'
  end

end