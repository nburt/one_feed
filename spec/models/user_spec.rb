require 'spec_helper'

describe User do
  describe 'omniauth login' do
    before do
      @user = User.new(:provider => 'twitter', :uid => '2343794081', :name => 'User Name')
    end

    it 'can create a user with omniauth' do
      expect(@user).to be_valid
    end

    it 'cannot create a user without a provider' do
      @user.provider = nil
      expect(@user).to_not be_valid
    end

    it 'cannot create a user without a uid' do
      @user.uid = nil
      expect(@user).to_not be_valid
    end

    it 'cannot create a user without a name' do
      @user.name = nil
      expect(@user).to_not be_valid
    end

    it 'can find a user by provider and uid' do
      User.create(:provider => 'twitter', :uid => '2343794082', :name => 'User Name')
      user = User.find_by_provider_and_uid('twitter', '2343794082')
      expect(user.name).to eq 'User Name'
      expect(user.provider).to eq 'twitter'
      expect(user.uid).to eq '2343794082'
    end
  end
end
