require 'spec_helper'

describe Facebook::Post do

  let(:posts) { Oj.load(File.read("./spec/support/facebook/facebook_post_creator_data.json")) }

  it 'can create instances facebook api hashes' do
    facebook_api_hash = posts[0]

    facebook_post = Facebook::Post.from(facebook_api_hash)

    expect(facebook_post.created_time).to eq Time.parse("2014-06-05T20:21:57+0000")
  end

end