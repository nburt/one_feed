module ApplicationHelper

  def current_user_has_provider?(provider)
    current_user.providers.by_name(provider).any?
  end

  def twitter_timeline
    provider = current_user.providers.first
    client = provider.configure_twitter(provider.twitter_access_token, provider.twitter_access_token_secret)
    client.home_timeline
  end
end
