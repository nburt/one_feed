class PasswordsController < ApplicationController

  def reset
    @user = User.new
  end

  def send_email
    user = User.find_by(email: params[:email])
    if user
      message = Rails.application.message_verifier(:message).generate([user.id, Time.now + 1.days])
      PasswordMailer.reset_password(user, message).deliver
    else
      PasswordMailer.wrong_email(params[:email]).deliver
    end
    flash[:reset_password_email_sent] = "An email has been sent to #{params[:email]} with further instructions on how to reset your password."
    redirect_to root_path
  end

  def edit
    begin
      @message = Rails.application.message_verifier(:message).verify(params[:message])
      @user = User.find(@message[0])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      render "public/404", layout: false
    end
  end

  def update
    if Time.now > params[:user][:token_expiration]
      @user = User.find(params[:user][:id])
      flash[:expired_token] = "Your password reset token has expired. Please request a new one by filling out the form below."
      redirect_to forgot_password_path
    else
      @user = User.find(params[:user][:id])
      if @user.update_attributes(secure_params)
        flash[:updated_password] = "Your password has been updated. You may now sign in with your email and updated password."
        redirect_to root_path
      else
        @message = [params[:user][:id], params[:user][:token_expiration]]
        @user = User.find(@message[0])
        flash[:passwords_dont_match] = "Your password and password confirmation do not match."
        render 'edit'
      end
    end
  end

  private

  def secure_params
    params.require(:user).permit(:password.presence, :password_confirmation.presence)
  end

end