require 'spec_helper'

feature 'Homepage with login' do

  before do
    stub_request(:post, "https://api.twitter.com/oauth2/token")

    stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json').
      to_return(body: File.read(File.expand_path("./spec/support/timeline.json")))

    visit '/'
    within 'div#onefeed_registration' do
      fill_in 'user[email]', :with => 'nate@email.com'
      fill_in 'user[password]', :with => 'password'
      click_button 'Sign Up'
    end
  end

  scenario 'user can logout and log back in without re-registering' do
    expect(page).to have_content 'Link Twitter'
    click_link 'Sign Out'
    within 'div#onefeed_login_container' do
      fill_in 'user[email]', :with => 'nate@email.com'
      fill_in 'user[password]', :with => 'password'
      click_button 'Sign In'
    end
    expect(page).to have_content 'Link Twitter'
  end

  scenario 'a user cannot login with incorrect credentials' do
    click_link 'Sign Out'
    within 'div#onefeed_login_container' do
      fill_in 'user[email]', :with => 'nate@email.com'
      fill_in 'user[password]', :with => 'password1'
      click_button 'Sign In'
    end
    expect(page).to have_content 'Invalid email or password'
  end

  scenario 'a user can associate a Twitter account' do
    mock_auth_hash
    click_link 'twitter_login_link'
    expect(page).to have_content 'Link Twitter'
    expect(page).to have_content 'Gillmor Gang Live'
  end

  scenario 'a user can dissociate a Twitter account' do
    pending
    click_link 'Unlink Twitter account'
    expect(page).to have_css '#twitter_login_link'
  end

  scenario 'it can handle authentication errors' do
    OmniAuth.config.mock_auth[:twitter] = :invalid
    visit '/'
    click_link 'twitter_login_link'
    expect(page).to have_content 'Authentication failed.'
  end
end