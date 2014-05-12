require 'spec_helper'

describe FeedController do

  let(:user) { User.create!(:email => 'nate@example.com', :password => 'password') }

  describe 'the create action' do
    describe 'when a user\'s authentication is expired' do
      before do
        session[:user_id] = user.id
        Token.create!(:provider => 'twitter', :uid => '1237981238', :user_id => user.id)
        allow_any_instance_of(Twitter::REST::Client).to receive(:home_timeline).and_raise(Twitter::Error::Forbidden)
      end

      render_views

      it 'redirects back to the Twitter auth page' do
        get 'index'
        expect(response).to redirect_to('/auth/twitter')
      end

    end
  end
end