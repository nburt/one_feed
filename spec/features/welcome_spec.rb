require 'spec_helper'

feature 'Homepage with login' do

  before do
    visit '/'
    within 'div#onefeed_registration' do
      fill_in 'user[email]', :with => 'nate@email.com'
      fill_in 'user[password]', :with => 'password'
      click_button 'Sign Up'
    end
  end

  scenario 'user can logout and log back in without re-registering' do
    expect(page).to have_content 'Account Settings'
    within '#logged_in_nav' do
      click_link 'Sign Out'
    end
    within 'header' do
      fill_in 'user[email]', :with => 'nate@email.com'
      fill_in 'user[password]', :with => 'password'
      click_button 'Sign In'
    end
    expect(page).to have_content 'Account Settings'
  end

  scenario 'a user cannot login with incorrect credentials' do
    within '#logged_in_nav' do
      click_link 'Sign Out'
    end
    within 'header' do
      fill_in 'user[email]', :with => 'nate@email.com'
      fill_in 'user[password]', :with => 'password1'
      click_button 'Sign In'
    end
    expect(page).to have_content 'Invalid email or password'
  end

end