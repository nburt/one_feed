require 'spec_helper'

describe FacebookValidator do

  let(:token) { Token.new }
  let(:validator) { FacebookValidator.new(token) }

  describe 'validating the token against Facebook' do

    subject { validator.valid? }

    describe 'when the token is valid' do
      before do
        stub_request(:get, 'https://graph.facebook.com/me/home?access_token=').
          to_return(status: 200)
      end
      it { should be_true }
    end

    describe 'when the token has expired' do
      before do
        stub_request(:get, 'https://graph.facebook.com/me/home?access_token=').
          to_return(status: 463)
      end
      it { should be_false }
    end

    describe 'when the token has expired, with a different status code' do
      before do
        stub_request(:get, 'https://graph.facebook.com/me/home?access_token=').
          to_return(status: 467)
      end
      it { should be_false }
    end

  end
end