require 'spec_helper'

describe InstagramValidator do

  let(:token) { Token.new }
  let(:validator) { InstagramValidator.new(token) }

  describe 'validating the token against Instagram' do

    subject { validator.valid? }

    describe 'when the token is valid' do
      before do
        stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=').
          to_return(status: 200)
      end
      it { should be_true }
    end

    describe 'when the token has expired' do
      before do
        stub_request(:get, 'https://api.instagram.com/v1/users/self/feed?access_token=').
          to_return(status: 400)
      end
      it { should be_false }
    end

  end
end