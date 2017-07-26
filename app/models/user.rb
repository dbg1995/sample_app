class User < ApplicationRecord
  attr_accessor :remember_token # create atrribute for User
  before_save{email.downcase!} # before save into DB + standard for email in DB
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  # gem bcrypt has virtual password and password_confirmation attributes
  # authenticate confirm user by compare password with password_disert in DB
  # save a password_digest attribute to the database
  #
  # validates presence on create that catches nil, passwords,but not "  "
  # when create -> params[p] = "" -> @user.p = nil -> check -> validates
  # presence of h_s_p on create => invalid. if params[p] = "123456" -> @user.p =
  # params[p] -> check -> validates p_confirmation of h_s_p + validates => valid
  #
  # when update -> params[p] = "" -> @user.p = nil -> check -> validates
  # presence of h_s_p: not on update + allow_nil: true in validates => valid
  # if params[p] = "123456" -> @user.p = params[p] -> check -> p_confirmation of
  # h_s_p + validates => valid
  #
  # when login -> haven't session models so use authenticate -> valid -> remember
  # -> update_attributes with @user in DB, if params[p] = "" -> @user.p = nil
  # but not create action so validates presence of h_s_p not check + allow_nil:
  # true in validates -> valid. if params[p] = "123456" @user.p = params[p] ->
  # check -> validates p_confirmation of h_s_p + validates => valid
  #
  # create digest
  def self.digest string
    cost =
      if ActiveModel::SecurePassword.min_cost
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
    update_attributes remember_digest: User.digest(remember_token)
  end

  # check remember_token when login
  def authenticated? remember_token
    # fix error logout browser1, browser2 close and reopen can Password.new(nil)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end
end
