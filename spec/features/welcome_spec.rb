require 'spec_helper'

feature 'Homepage with login' do

  before do
    stub_request(:post, "https://api.twitter.com/oauth2/token")

    stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json').
      to_return(body: File.read(File.expand_path("./spec/support/timeline.json")))
  end

  scenario 'user can register with OneFeed' do
    visit '/'
    click_link 'Register with OneFeed'
    fill_in 'user[email]', :with => 'nate@email.com'
    fill_in 'user[password]', :with => 'password'
    click_button 'Register'
    expect(page).to have_content 'Welcome to OneFeed'
  end

  scenario 'user can visit homepage and will see text' do
    visit '/'
    within 'header' do
      click_link 'OneFeed'
    end
    expect(page).to have_content 'Get Started'
    expect(page).to have_content 'Login with Facebook'
    expect(page).to have_content 'Login with Twitter'
  end

  context 'old tests', pending: true do
    scenario 'a user can login with Twitter and logout' do
      visit '/'
      mock_auth_hash
      click_link 'twitter_login_link'
      expect(page).to have_content 'My Feed'
      expect(page).to have_content 'Gillmor Gang Live'
      click_link 'Logout'
      expect(page).to have_content 'Login with Twitter'
    end

    scenario 'it can handle authentication errors' do
      OmniAuth.config.mock_auth[:twitter] = :invalid
      visit '/'
      click_link 'twitter_login_link'
      expect(page).to have_content 'Authentication failed.'
    end
  end
end