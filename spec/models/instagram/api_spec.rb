require 'spec_helper'

describe Instagram::Api do

  it 'can get the instagram timeline for a given user' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(body: File.read(File.expand_path('./spec/support/instagram/instagram_timeline.json')))
    instagram_api = Instagram::Api.new('mock_token', nil)
    timeline = instagram_api.get_timeline
    expect(timeline.posts[0]["caption"]["text"]).to eq 'The girls #pumped #herewego'
  end

  it 'will return true if successful' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(body: File.read(File.expand_path('./spec/support/instagram/instagram_timeline.json')))
    instagram_api = Instagram::Api.new('mock_token', nil)
    timeline = instagram_api.get_timeline
    expect(timeline.success?).to eq true
  end

  it 'will return an empty array if the users\'s token is no longer valid' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(status: 400)
    instagram_api = Instagram::Api.new('mock_token', nil)
    begin
      timeline = instagram_api.get_timeline
    rescue Instagram::Unauthorized
      expect(timeline.posts).to eq []
    end
  end

  it 'will raise an exception if the user\'s token is no longer valid' do
    stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=mock_token&count=5').
      to_return(status: 400)
    instagram_api = Instagram::Api.new('mock_token', nil)
    begin
      timeline = instagram_api.get_timeline
    rescue
      expect(timeline.authed?).to eq 'This user\'s token is no longer valid.'
    end
  end

  it 'will allow a user to like a post' do
    stub_request(:post, 'https://api.instagram.com/v1/media/1/likes?access_token=mock_token').
      to_return(:status => 200, :body => File.read('./spec/support/instagram/instagram_like_response.json'))
    instagram_api = Instagram::Api.new('mock_token', nil)
    expect(instagram_api.like_post(1).body).to eq File.read('./spec/support/instagram/instagram_like_response.json')
  end

  it 'can get comments for a given media post' do
    stub_request(:get, 'https://api.instagram.com/v1/media/717696748386385949_54975383/comments?access_token=mock_token').
      to_return(body: File.read('./spec/support/instagram/instagram_post_comments.json'))

    instagram_api = Instagram::Api.new('mock_token', nil)
    comments_response = instagram_api.get_comments('717696748386385949_54975383')
    result = comments_response.parse

    expect(result[2]['text']).to eq 'Yeah'
    expect(result[1]['created_time']).to eq '1399776401'
  end
end