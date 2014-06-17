require 'spec_helper'

feature 'Homepage with login' do

  context "logging in" do
    scenario 'user can logout and log back in without re-registering' do
      @user = create_user
      login_user(@user)
      expect(page).to have_content 'Account Settings'
      click_link 'Sign Out'
      login_user(@user)
      expect(page).to have_content 'Account Settings'
    end

    scenario 'a user cannot login with incorrect credentials' do
      @user = create_user
      login_user(@user)
      click_link 'Sign Out'
      within 'header' do
        fill_in 'user[email]', :with => 'nate@email.com'
        fill_in 'user[password]', :with => 'password1'
        click_button 'Sign In'
      end
      expect(page).to have_content 'Invalid email or password'
    end
  end

  context "privacy policy" do
    scenario 'a user can view our privacy policy' do
      visit '/'
      click_link 'Privacy Policy'
      expect(page).to have_content 'This Privacy Policy governs the manner in which OneFeed collects, uses, maintains and discloses information collected from users'
    end
  end

end