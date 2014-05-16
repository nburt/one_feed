class User < ActiveRecord::Base

  has_secure_password

  validates :email, presence: true, uniqueness: true

  has_many :tokens, dependent: :destroy


  def validate_tokens!
    tokens.each(&:validate_token!)
  end

end

