require 'spec_helper'

describe Facebook::Api do

  it 'can get the facebook timeline for a given user' do
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook/facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))

    facebook_api = Facebook::Api.new('mock_token')
    facebook_api.timeline
    expect(facebook_api.facebook_timeline_response.posts[0]["id"]).to eq '10202029985566360_10202029328989946'
  end

  it 'will return true if successful' do
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook/facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))

    facebook_api = Facebook::Api.new('mock_token')
    facebook_api.timeline
    expect(facebook_api.facebook_timeline_response.success?).to eq true
  end

  it 'will return an empty array if the users\'s token is no longer valid' do
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(status: 463, body: File.read('./spec/support/facebook/invalid_oauth_token.json'))

    facebook_api = Facebook::Api.new('mock_token')
    begin
      facebook_api.timeline
    rescue Facebook::Unauthorized
      expect(facebook_api.facebook_timeline_response.posts).to eq []
    end
  end

  it 'will raise an exception if the user\'s token is no longer valid' do
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(status: 463)

    facebook_api = Facebook::Api.new('mock_token')
    expect { facebook_api.timeline }.to raise_exception(Facebook::Unauthorized)
    begin
      facebook_api.timeline
    rescue Facebook::Unauthorized
      expect(facebook_api.facebook_timeline_response.authed?).to eq false
    end
  end

  it 'will return a user\'s profile picture' do
    stub_request(:get, 'https://graph.facebook.com/v2.0/me/home?access_token=mock_token&limit=5').
      to_return(body: File.read('./spec/support/facebook/facebook_timeline.json'))
    stub_request(:get, 'https://graph.facebook.com/10203694030092980/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))

    facebook_api = Facebook::Api.new('mock_token')
    facebook_api.timeline
    expect(facebook_api.facebook_timeline_response.poster_recipient_profile_hash['10203694030092980']).to eq 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg'
  end

  it 'can create a post' do
    json = <<-JSON
{
  "id": "10201957829522504_10202145730539912"
}
    JSON

    stub_request(:post, 'https://graph.facebook.com/v2.0/me/feed?access_token=mock_token&message=hello%20there').
      to_return(:status => 200, :body => json)

    facebook_api = Facebook::Api.new('mock_token')
    expect(facebook_api.create_post('hello there')).to eq '10201957829522504_10202145730539912'
  end

  it 'will raise an exception if creating a post is not successful' do
    stub_request(:post, 'https://graph.facebook.com/v2.0/me/feed?access_token=mock_token&message=hello%20there').
      to_return(:status => 463)

    facebook_api = Facebook::Api.new('mock_token')
    expect { facebook_api.create_post('hello there') }.to raise_exception(Facebook::Unauthorized)
    begin
      facebook_api.create_post('hello there')
    rescue Facebook::Unauthorized
      expect(facebook_api.facebook_post_response.authed?).to eq false
    end
  end

  it 'can like a post' do
    stub_request(:post, 'https://graph.facebook.com/v2.0/1/likes?access_token=mock_token').
      to_return(:status => 200, :body => true)
    facebook_api = Facebook::Api.new('mock_token')
    expect(facebook_api.like_post(1).body).to eq true
  end

  it 'can get a single post' do
    stub_request(:get, 'https://graph.facebook.com/v2.0/10201999791700227_10202101615725764?access_token=mock_token').
      to_return(:status => 200, :body => File.read('./spec/support/facebook/facebook_post.json'))
    stub_request(:get, 'https://graph.facebook.com/10201999791700227/picture?redirect=false').
      to_return(:status => 200, :body => File.read('./spec/support/facebook/facebook_profile_picture_request.json'))
    facebook_api = Facebook::Api.new('mock_token')
    facebook_api.get_post('10201999791700227_10202101615725764')
    expect(facebook_api.facebook_post_response.post['from']['id']).to eq '10201999791700227'
    expect(facebook_api.facebook_post_response.poster_profile_picture).to eq({:profile_picture_url => 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/p50x50/10359166_10202087887622570_1663761395861545071_s.jpg'})
  end

  it 'will return true if successful' do
    json = <<-JSON
{
  "id": "10201999791700227_10202101615725764"
}
    JSON

    stub_request(:get, 'https://graph.facebook.com/v2.0/10201999791700227_10202101615725764?access_token=mock_token').
      to_return(body: File.read('./spec/support/facebook/facebook_post.json'))
    stub_request(:get, 'https://graph.facebook.com/10201999791700227/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))
    stub_request(:post, "https://graph.facebook.com/v2.0/me/feed?access_token=mock_token&message=hello%20there").
      to_return(:status => 200, :body => json)

    facebook_api = Facebook::Api.new('mock_token')
    post_id = facebook_api.create_post('hello there')
    facebook_api.get_post(post_id)
    expect(facebook_api.facebook_post_response.success?).to eq true
  end

  it 'will return an empty array if the users\'s token is no longer valid' do
    json = <<-JSON
{
  "id": "10201999791700227_10202101615725764"
}
    JSON

    stub_request(:get, 'https://graph.facebook.com/v2.0/10201999791700227_10202101615725764?access_token=mock_token').
      to_return(status: 463)
    stub_request(:get, 'https://graph.facebook.com/10201999791700227/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))
    stub_request(:post, 'https://graph.facebook.com/v2.0/me/feed?access_token=mock_token&message=hello%20there').
      to_return(:status => 200, :body => json)

    facebook_api = Facebook::Api.new('mock_token')
    post_id = facebook_api.create_post('hello there')

    begin
      facebook_api.get_post(post_id)
    rescue Facebook::Unauthorized
      expect(facebook_api.facebook_post_response.post).to eq []
    end
  end

  it 'will raise an exception if the user\'s token is no longer valid' do
    json = <<-JSON
{
  "id": "10201999791700227_10202101615725764"
}
    JSON

    stub_request(:get, 'https://graph.facebook.com/v2.0/10201999791700227_10202101615725764?access_token=mock_token').
      to_return(status: 463)
    stub_request(:get, 'https://graph.facebook.com/10201999791700227/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))
    stub_request(:post, 'https://graph.facebook.com/v2.0/me/feed?access_token=mock_token&message=hello%20there').
      to_return(:status => 200, :body => json)

    facebook_api = Facebook::Api.new('mock_token')
    post_id = facebook_api.create_post('hello there')
    expect { facebook_api.get_post(post_id) }.to raise_exception(Facebook::Unauthorized)
    begin
      facebook_api.get_post(post_id)
    rescue Facebook::Unauthorized
      expect(facebook_api.facebook_post_response.authed?).to eq false
    end
  end

  it 'will return comments for a post along with the profile pictures for the commenters' do
    stub_request(:get, 'https://graph.facebook.com/v2.0/10152071074642001_10152132612117001/comments?access_token=mock_token').
      to_return(:body => File.read('./spec/support/facebook/facebook_comments_request.json'))
    stub_request(:get, 'https://graph.facebook.com/10154126526645244/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_1.json'))
    stub_request(:get, 'https://graph.facebook.com/10152071074642001/picture?redirect=false').
      to_return(:body => File.read('./spec/support/facebook/picture_response_10.json'))

    facebook_api = Facebook::Api.new('mock_token')
    facebook_api.get_comments('10152071074642001_10152132612117001')
    comments_response = facebook_api.facebook_post_response
    expect(comments_response.post[0]['message']).to eq 'Surround yourself with people who make you a better person.'
    expect(comments_response.commenter_profile_hash['10154126526645244']).to eq 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/t1.0-1/c10.0.50.50/p50x50/544089_10202552316910864_1418490882_s.jpg'
  end

end