require 'spec_helper'

describe User do

  describe 'registration' do

    before do
      DatabaseCleaner.clean
      @user = User.create!(:email => 'nate@example.com', :password => 'password')
    end

    it 'cannot create a user without an email' do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it 'cannot create a user without a password' do
      @user.password_digest = nil
      expect(@user).to_not be_valid
    end

    it 'cannot create a user with the same email' do
      user = User.create(:email => 'nate@example.com', :password => 'password')
      expect(user).to_not be_valid
    end
  end

end
