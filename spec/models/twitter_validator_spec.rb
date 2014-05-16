require 'spec_helper'

describe TwitterValidator do

  let(:token) { Token.new }
  let(:validator) { TwitterValidator.new(token) }

  describe 'validating the token against Twitter' do

    subject { validator.valid? }

    describe 'when the token is valid' do
      before { Twitter::REST::Client.any_instance.stub(:home_timeline).and_return([]) }
      it { should be_true }
    end

    describe 'when the token has expired' do
      before { Twitter::REST::Client.any_instance.stub(:home_timeline).and_raise(Twitter::Error::Forbidden) }
      it { should be_false }
    end

  end
end