class PasswordMailer < ActionMailer::Base

  default from: "no_reply@onefeed.com"

  def reset_password(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: "OneFeed password reset request")
  end

  def wrong_email(email)
    @email = email
    mail(to: @email, subject: "OneFeed password reset attempt")
  end

end