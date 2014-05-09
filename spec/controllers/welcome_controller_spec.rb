require 'spec_helper'


describe WelcomeController do
  context 'old tests', pending: true do

    let(:user) { User.create!(:provider => 'twitter', :uid => '2343794081', :name => 'User Name') }

    describe 'the index action' do
      describe 'when a user\'s authentication is expired' do
        before do
          session[:user_id] = user.id
          allow_any_instance_of(Twitter::REST::Client).to receive(:home_timeline).and_raise(Twitter::Error::Forbidden)
        end

        it 'redirects back to the Twitter auth page' do
          get 'index'
          expect(response).to redirect_to('/auth/twitter')
        end

      end
    end
  end
end