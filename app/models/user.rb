class User < ActiveRecord::Base

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :tokens, dependent: :destroy

  def validate_tokens!
    tokens.each(&:validate_token!)
  end

end

