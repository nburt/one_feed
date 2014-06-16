require 'spec_helper'

describe User do

  describe 'registration' do

    before do
      @user = create_user
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
      user = User.new(:email => 'nate@example.com', :password => 'password')
      expect(user).to_not be_valid
    end

    it 'cannot create a user without a first name' do
      @user.first_name = nil
      expect(@user).to_not be_valid
    end

    it 'cannot create a user without a last name' do
      @user.last_name = nil
      expect(@user).to_not be_valid
    end
  end

end
