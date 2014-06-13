require 'spec_helper'

describe Providers do

  it 'knows what providers are available for a user' do
    user = User.create!(email: 'nate@example.com', password: 'password')
    Token.create!(user_id: user.id, provider: 'facebook', uid: '1', access_token: '11234', access_token_secret: '31413')

    providers = Providers.for(user)

    expect(providers.facebook?).to eq true
    expect(providers.twitter?).to eq false
    expect(providers.instagram?).to eq false
  end

  it 'knows if the user has any providers' do
    user = User.create!(email: 'nate@example.com', password: 'password')
    providers = Providers.for(user)

    expect(providers.none?).to eq true

    Token.create!(user_id: user.id, provider: 'facebook', uid: '1', access_token: '11234', access_token_secret: '31413')

    expect(providers.none?).to eq false

    Token.destroy_all

    Token.create!(user_id: user.id, provider: 'instagram', uid: '1', access_token: '11234', access_token_secret: '31413')

    expect(providers.none?).to eq false

    Token.destroy_all

    Token.create!(user_id: user.id, provider: 'twitter', uid: '1', access_token: '11234', access_token_secret: '31413')

    expect(providers.none?).to eq false
  end

end