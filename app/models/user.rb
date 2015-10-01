class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

 has_secure_password
  # using this has secure password creates virtual attributes that dont exist in the databse: password and password_confirmation.

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def User.digest(string)
    # cost is the cost parameter that determines the computational cost to calculate the hash. Using a high cost makes it computationally intractable to use the hash to determine the original password, which is an important security precaution in a production environment, but in tests we want the digest method to be as fast as possible.
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

# forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

# returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    # so here we compare the remember token, to the remember digest
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

end