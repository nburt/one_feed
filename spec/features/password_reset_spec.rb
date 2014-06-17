require 'spec_helper'

feature 'password reset' do

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

  scenario 'a user tries to reset their password with an email address that does not exist' do
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
      fill_in 'email', :with => 'burt@example.com'
      click_button 'Reset Password'
    end

    expect(ActionMailer::Base.deliveries.length).to eq(emails_sent + 1)
    expect(page).to have_content 'An email has been sent to burt@example.com with
                                    further instructions on how to reset your password.'

    email_message = ActionMailer::Base.deliveries.last.body.parts[1].body.raw_source

    @doc = Nokogiri::HTML(email_message)

    expect(email_message).to include 'Hi burt@example.com, you are receiving this email because you (or someone else)'
  end

  scenario 'a user tries to reset their password but their token has expired' do
    user = User.create!(first_name: 'Nate', last_name: 'Burt', email: 'nate@example.com', password: 'password')
    message = Rails.application.message_verifier(:message).generate([user.id, Time.now - 1.days])
    PasswordMailer.reset_password(user, message).deliver

    email_message = ActionMailer::Base.deliveries.last.body.parts[1].body.raw_source

    @doc = Nokogiri::HTML(email_message)

    result = @doc.xpath("//a").first['href']

    visit result

    within '.content_container' do
      fill_in 'user[password]', :with => 'password2'
      fill_in 'user[password_confirmation]', :with => 'password2'
      click_button 'Update Password'
    end

    expect(page).to have_content 'Your password reset token has expired. Please request a new one by filling out the form below.'
    current_url.should eq ("http://example.com/passwords/reset")
  end

  scenario 'user cannot visit the /passwords/edit page if they do not have a message param with the token' do
    visit '/passwords/edit'
    expect(page).to have_content "The page you were looking for doesn't exist."
  end

end