require 'spec_helper'

feature 'Homepage with login' do

  context "password reset" do
    scenario 'a user can reset their password' do
      visit '/'
      within '#onefeed_registration_container' do
        fill_in 'user[first_name]', :with => 'Nate'
        fill_in 'user[last_name]', :with => 'Burt'
        fill_in 'user[email]', :with => 'nate@example.com'
        fill_in 'user[password]', :with => 'password'
        click_button 'Sign Up'
      end

      click_link 'Sign Out'

      emails_sent = ActionMailer::Base.deliveries.length

      click_link 'Forgot Password?'
      within '.content_container' do
        fill_in 'email', :with => 'nate@example.com'
        click_button 'Reset Password'
      end

      expect(ActionMailer::Base.deliveries.length).to eq(emails_sent + 1)
      expect(page).to have_content 'An email has been sent to nate@example.com with
                                    further instructions on how to reset your password.'

      email_message = ActionMailer::Base.deliveries.last.body.parts[1].body.raw_source

      @doc = Nokogiri::HTML(email_message)

      result = @doc.xpath("//a").first['href']

      visit result

      within '.content_container' do
        fill_in 'user[password]', :with => 'password2'
        fill_in 'user[password_confirmation]', :with => 'password2'
        click_button 'Update Password'
      end

      expect(page).to have_content 'Your password has been updated. You may now sign in with your email and updated password.'

      within 'header' do
        fill_in 'user[email]', :with => 'nate@example.com'
        fill_in 'user[password]', :with => 'password2'
        click_button 'Sign In'
      end

      expect(page).to have_content 'Sign Out'
    end

  end

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