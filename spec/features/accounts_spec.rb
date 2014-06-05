require 'spec_helper'

feature 'accounts pages' do

  scenario 'a user cannot visit an account page that is not theirs' do
    nate = User.create!(:email => 'nate@example.com', :password => 'password')
    burt = User.create!(:email => 'burt@example.com', :password => 'password')

    visit '/'
    within 'header' do
      fill_in 'user[email]', :with => 'nate@example.com'
      fill_in 'user[password]', :with => 'password'
      click_button 'Sign In'
    end

    visit "/accounts/#{burt.id}/settings"
    expect(page).to have_content "The page you were looking for doesn't exist (404)"
    visit "/accounts/#{burt.id}"
    expect(page).to have_content "The page you were looking for doesn't exist (404)"
  end

  scenario 'a user can visit an account page that is theirs' do
    visit '/'
    within 'div#onefeed_registration' do
      fill_in 'user[email]', :with => 'nate@email.com'
      fill_in 'user[password]', :with => 'password'
      click_button 'Sign Up'
    end

    click_link 'Account Settings'
    click_link 'Link Accounts'
    expect(page).to have_content 'Link Facebook'
  end

end