class FeedController < ApplicationController

  def index
    @twitter_timeline = if current_user_has_provider?('twitter')
                          token = current_user.tokens.find_by(provider: 'twitter')
                          client = token.configure_twitter(token.access_token, token.access_token_secret)
                          client.home_timeline
                        else
                          []
                        end

    @instagram_timeline = if current_user_has_provider?('instagram')
                            token = current_user.tokens.find_by(provider: 'instagram')
                            instagram_api = InstagramApi.new(token.access_token)
                            instagram_api.timeline
                          else
                            []
                          end

    render 'welcome/feed'
  end

  private

  def current_user_has_provider?(provider)
    current_user.tokens.by_name(provider).any?
  end

end