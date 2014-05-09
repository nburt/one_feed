class User < ActiveRecord::Base

  has_secure_password

  validates :email, presence: true

  def self.update_or_create_with_omniauth(auth)
    user = where(provider: auth["provider"], uid: auth["uid"]).first_or_initialize
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.name = auth["info"]["name"]
    user.access_token = auth["extra"]["access_token"].token
    user.access_token_secret = auth["extra"]["access_token"].secret
    user.save!
    user
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

