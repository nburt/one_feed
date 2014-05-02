class WelcomeController < ApplicationController

  def index
    @failure = session[:auth_failure]
  end

end