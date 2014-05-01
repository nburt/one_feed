require 'spec_helper'

feature 'Homepage with login' do

  scenario 'user can visit homepage and will see text' do
    visit '/'
    click_link 'OneFeed'
    expect(page).to have_content 'Get Started'
    expect(page).to have_content 'Login with Facebook'
    expect(page).to have_content 'Login with Twitter'
  end
end