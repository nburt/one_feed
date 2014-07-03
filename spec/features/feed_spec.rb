require 'spec_helper'

feature 'can display feeds from various social media accounts', js: true do

  before do
    insert_feed_feature_stubs
    user = create_user
    login_user(user)
  end

  context "associating accounts/ viewing feeds" do
    scenario 'a user can associate a Twitter account' do
      mock_auth_hash
      click_link 'Account Settings'
      click_link 'Link Accounts'
      click_link 'Link Twitter'
      expect(page).to have_content 'Account Settings'
      expect(page).to have_content 'Gillmor Gang Live'
      click_on 'Toggle Twitter'
      expect(page).to_not have_content 'Gillmor Gang Live'
      click_on 'Toggle Twitter'
      expect(page).to have_content 'Gillmor Gang Live'
    end

    scenario 'a user can associate an Instagram account' do
      mock_auth_hash
      click_link 'Account Settings'
      click_link 'Link Accounts'
      click_link 'Link Instagram'
      expect(page).to have_content 'Account Settings'
      expect(page).to have_content 'The girls #pumped #herewego'
      expect(page).to_not have_content 'Nice thats a good one love the stash'
      page.all(:link,"View Comments")[0].click
      expect(page).to have_content 'Nice thats a good one love the stash'
      click_on 'Hide Comments'
      expect(page).to_not have_content 'Nice thats a good one love the stash'
      click_on 'Toggle Instagram'
      expect(page).to_not have_content 'The girls #pumped #herewego'
      click_on 'Toggle Instagram'
      expect(page).to have_content 'The girls #pumped #herewego'
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
      page.all(:link,"View Comments")[0].click
      expect(page).to have_content 'Surround yourself with people who make you a better person.'
      click_on 'Hide Comments'
      expect(page).to_not have_content 'Surround yourself with people who make you a better person.'
      click_on 'Toggle Facebook'
      expect(page).to_not have_content 'Any good food in San Fran?'
      click_on 'Toggle Facebook'
      expect(page).to have_content 'Any good food in San Fran?'
    end
  end

  context "authentication errors" do
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
  end

  context "creating posts" do
    scenario 'a user can see a checkbox to post to Facebook only if they have linked their facebook account' do
      mock_auth_hash
      click_link 'Account Settings'
      click_link 'Link Accounts'
      click_link 'Link Twitter'
      click_link 'Create Post'

      within '#create_posts_container' do
        expect(page).to have_content 'Choose which networks to post to:'
        expect(page).to have_content 'Twitter'
        expect(page).to_not have_content 'Facebook'
      end

      click_link 'Account Settings'
      click_link 'Link Accounts'
      click_link 'Link Facebook'
      click_link 'Create Post'

      within '#create_posts_container' do
        expect(page).to have_content 'Twitter'
        expect(page).to have_content 'Facebook'
      end
    end
  end

end