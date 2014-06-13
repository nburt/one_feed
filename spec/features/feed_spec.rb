require 'spec_helper'

feature 'can display feeds from various social media accounts', js: true do

  before do
    insert_feed_feature_stubs

    visit '/'
    within '#onefeed_registration' do
      fill_in 'user[email]', :with => 'nate@email.com'
      fill_in 'user[password]', :with => 'password'
      click_button 'Sign Up'
    end
  end

  scenario 'a user can associate a Twitter account' do
    mock_auth_hash
    click_link 'Account Settings'
    click_link 'Link Accounts'
    click_link 'Link Twitter'
    expect(page).to have_content 'Account Settings'
    expect(page).to have_content 'Gillmor Gang Live'
  end

  scenario 'it can handle authentication errors' do
    silence_omniauth do
      OmniAuth.config.mock_auth[:twitter] = :invalid
      visit '/'
      click_link 'Account Settings'
      click_link 'Link Accounts'
      click_link 'Link Twitter'
      expect(page).to have_content 'Authentication failed.'
    end
  end

  scenario 'a user can associate an Instagram account' do
    mock_auth_hash
    click_link 'Account Settings'
    click_link 'Link Accounts'
    click_link 'Link Instagram'
    expect(page).to have_content 'Account Settings'
    expect(page).to have_content 'The girls #pumped #herewego'
    expect(page).to have_content 'Yesss'
  end

  scenario 'a user can login without associating a social media account' do
    expect(page).to have_content 'Account Settings'
    expect(page).to have_content 'Sign Out'
    expect(page).to have_content 'Click one of the below links or visit "Account Settings" to link an account and get started.'
  end

  scenario 'a user can associate a Facebook account and view recent posts in their feed' do
    mock_auth_hash
    click_link 'Account Settings'
    click_link 'Link Accounts'
    click_link 'Link Facebook'

    expect(page).to have_content 'Account Settings'
    expect(page).to have_content 'Any good food in San Fran?'
  end

  scenario 'a user can see a checkbox to post to Facebook only if they have linked their facebook account' do
    mock_auth_hash
    click_link 'Account Settings'
    click_link 'Link Accounts'
    click_link 'Link Twitter'
    click_link 'Create Post'

    expect(page).to_not have_content 'Post to Facebook'

    click_link 'Account Settings'
      click_link 'Link Accounts'
    click_link 'Link Facebook'
    click_link 'Create Post'

    expect(page).to have_content 'Post to Twitter'
    expect(page).to have_content 'Post to Facebook'
  end

end