class User < ApplicationRecord
  attr_accessor :remember_token # create atrribute for User
  before_save{email.downcase!} # before save into DB + standard for email in DB
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  # add authenticate method, virtual password and password_confirmation
  # attributes, save a securely hashed password_digest attribute to the database
  # An authenticate method have ability  authenticate user by compare current
  # password with password_disert in DB
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  # create digest
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token #  create a token
    SecureRandom.urlsafe_base64
  end

  def remember
    # self refer to a user object instance => refer to remember_token attribute
    # of curent object
    self.remember_token = User.new_token
    # save digest of token into DB bypass validates
    update_attribute :remember_digest, User.digest(remember_token)
  end

  # check remember_token when login
  def authenticated? remember_token
    # fix error logout b1, b2 close and reopen can BCrypt::Password.new(nil)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
