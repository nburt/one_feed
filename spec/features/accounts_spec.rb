require 'spec_helper'

feature 'accounts pages' do

  context "users visiting accounts pages" do
    scenario 'a user cannot visit an account page that is not theirs' do
      nate = create_user
      burt = create_user(:email => 'burt@example.com')

      visit '/'
      login_user(nate)

      visit "/accounts/#{burt.id}/settings"
      expect(page).to have_content "The page you were looking for doesn't exist (404)"
      visit "/accounts/#{burt.id}"
      expect(page).to have_content "The page you were looking for doesn't exist (404)"
    end

    scenario 'a user can visit an account page that is theirs' do
      user = create_user
      login_user(user)
      visit '/'
      click_link 'Account Settings'
      click_link 'Link Accounts'
      expect(page).to have_content 'Link Facebook'
    end
  end

end