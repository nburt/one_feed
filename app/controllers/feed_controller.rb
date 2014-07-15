class FeedController < ApplicationController

  def index
    @providers = Providers.for(current_user)
    if @providers.none?
      @display_welcome = true
      render 'accounts/settings'
    end
  end

  def feed
    @feed_presenter = FeedPresenter.new(current_user, params)
    fragment = render_to_string 'feed/feed', layout: false
    render json: {unauthed_accounts: @feed_presenter.unauthed_accounts, fragment: fragment}
  end

  private

  def load_more_url
    feed_content_path(@feed_presenter.load_more_url_options)
  end
  helper_method :load_more_url

end