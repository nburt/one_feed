class FeedController < ApplicationController

  before_filter :check_token_validity

  def index
    feed = Feed.new(current_user)
    @timeline = feed.posts
    @unauthed_accounts = feed.unauthed_accounts
    @poster_recipient_profile_hash = feed.poster_recipient_profile_hash
    @commenter_profile_hash = feed.commenter_profile_hash

    render 'welcome/feed'
  end

  private

  def check_token_validity
    current_user.validate_tokens!
  end

end