module ApplicationHelper

  def current_user_has_provider?(provider)
    current_user.tokens.by_name(provider).any?
  end

  def twitter_timeline
    provider = current_user.tokens.find_by(provider: 'twitter')
    client = provider.configure_twitter(provider.access_token, provider.access_token_secret)
    client.home_timeline
  end

  def instagram_timeline
    provider = current_user.tokens.find_by(provider: 'instagram')
    instagram_api = InstagramApi.new(provider.access_token)
    @instagram_timeline = instagram_api.timeline
  end
end
