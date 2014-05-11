class Provider < ActiveRecord::Base

  validates :provider, presence: true
  validates :uid, presence: true

  belongs_to :user

  def self.by_name(name)
    where(provider: name)
  end

  def self.update_or_create_with_omniauth(id, auth)
    provider = where(provider: auth["provider"], uid: auth["uid"]).first_or_initialize
    provider.provider = auth["provider"]
    provider.uid = auth["uid"]
    provider.access_token = auth["extra"]["access_token"].token
    provider.access_token_secret = auth["extra"]["access_token"].secret
    provider.user_id = id
    provider.save!
    provider
  end

  def self.update_or_create_with_instagram_omniauth(id, auth)
    provider = where(provider: auth["provider"]).first_or_initialize
    provider.provider = auth["provider"]
    provider.uid = auth["uid"]
    provider.access_token = auth["credentials"]["token"]
    provider.user_id = id
    provider.save!
    provider
  end

  def configure_twitter(access_token, access_token_secret)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_API_KEY']
      config.consumer_secret = ENV['TWITTER_API_SECRET']
      config.access_token = access_token
      config.access_token_secret = access_token_secret
    end
    client
  end

end