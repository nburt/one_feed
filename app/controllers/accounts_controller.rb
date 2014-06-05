class AccountsController < ApplicationController

  before_action :is_correct_user?

  def show

  end

  def settings
    @display_welcome = false
  end

  private

  def is_correct_user?
    unless current_user.id == params[:id].to_i
      render "public/404"
    end
  end

end