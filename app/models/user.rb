class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token # create atrribute for User
  before_save :downcase_email # before save object into DB
  # only auto call after validates and before save with create to initialize
  # activation_digest and activation_token
  before_create :create_activation_digest
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
  # validates presence on create that catches nil, passwords,but not"  "
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
    # of curent object. inside class when write need self but read is need self
    self.remember_token = User.new_token
    # save digest of token into DB bypass validates
    update_attributes remember_digest: User.digest(remember_token)
  end

  # cover authenticate of h_s_p for check password to check something
  # note when login self.remember_token is nil, because we assign for it
  # remember_token paramaters is given from cookie
  def authenticated? attribute, token
    # we want to call a attribute or method of object but what doesn't us know
    # before, use send with message, then custom this message when excuse
    digest = send "#{attribute}_digest"
    # fix error logout browser1, browser2 close and reopen can Password.new(nil)
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  # Activates an account.
  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def self.select_user_activated
    User.where activated: true
  end

  private

  # Converts email to all lower-case - standard for email in DB
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token # vitrual abttribute
    self.activation_digest = User.digest activation_token # abttribute in DB
  end
end
