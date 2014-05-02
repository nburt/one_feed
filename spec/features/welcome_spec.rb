require 'spec_helper'

feature 'Homepage with login' do

  before do
    stub_request(:post, "https://api.twitter.com/oauth2/token")

    stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json').
      to_return(body: File.read(File.expand_path("./spec/support/timeline.json")))
  end

  scenario 'user can visit homepage and will see text' do
    visit '/'
    click_link 'OneFeed'
    expect(page).to have_content 'Get Started'
    expect(page).to have_content 'Login with Facebook'
    expect(page).to have_content 'Login with Twitter'
  end

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