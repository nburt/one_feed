class User < ActiveRecord::Base

  validates :provider, presence: true
  validates :uid, presence: true
  validates :name, presence: true

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end

  def find_by_provider_and_uid(provider, uid)
    User.find(:provider => provider, :uid => uid)
  end

end

