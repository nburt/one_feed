class Token < ActiveRecord::Base

  validates :provider, presence: true
  validates :uid, presence: true

  belongs_to :user

  after_initialize on: :create do
    self.is_valid = true
  end

  def self.by_name(name)
    where(provider: name)
  end

  def self.invalid
    where(is_valid: false)
  end

  def self.update_or_create_with_omniauth(id, auth)
    token = where(provider: auth["provider"], uid: auth["uid"]).first_or_initialize
    token.provider = auth["provider"]
    token.uid = auth["uid"]
    token.access_token = auth["extra"]["access_token"].token
    token.access_token_secret = auth["extra"]["access_token"].secret
    token.user_id = id
    token.is_valid = true
    token.save!
    token
  end

  def self.update_or_create_with_facebook_omniauth(id, auth)
    token = where(provider: auth["provider"]).first_or_initialize
    token.provider = auth["provider"]
    token.uid = auth["uid"]
    token.access_token = auth["credentials"]["token"]
    token.user_id = id
    token.is_valid = true
    token.save!
    token
  end

  def self.update_or_create_with_instagram_omniauth(id, auth)
    token = where(provider: auth["provider"]).first_or_initialize
    token.provider = auth["provider"]
    token.uid = auth["uid"]
    token.access_token = auth["credentials"]["token"]
    token.user_id = id
    token.is_valid = true
    token.save!
    token
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

  def validate_token!
    update_column :is_valid, "#{provider.titleize}Validator".constantize.new(self).valid?
  end

end