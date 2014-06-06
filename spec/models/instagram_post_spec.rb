require 'spec_helper'

describe InstagramPost do

  it 'can create instances from Instagram api hashes' do
    instagram_api_hash = {"created_time" => "1099841786"}

    instagram_post = InstagramPost.from(instagram_api_hash)

    expect(instagram_post.created_time).to eq Time.at(1099841786)
  end

  it 'can get the provider' do
    instagram_api_hash = {"created_time" => "1099841786"}

    instagram_post = InstagramPost.from(instagram_api_hash)

    expect(instagram_post.provider).to eq("instagram")
  end

end