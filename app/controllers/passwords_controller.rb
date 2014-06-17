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
    @message = Rails.application.message_verifier(:message).verify(params[:message])
    @user = User.find(@message[0])
  end

  def update
    if Time.now < params[:user][:token_expiration]
      @user = User.find(params[:user][:id])
      if @user.update_attributes(:password => params[:user][:password].presence, :password_confirmation => params[:user][:password_confirmation].presence)
        flash[:updated_password] = "Your password has been updated. You may now sign in with your email and updated password."
        redirect_to root_path
      end
    else
      render 'edit'
    end
  end

  private

  def secure_params
    params.require(:user).permit(:password)
  end

end