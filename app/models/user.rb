class User < ActiveRecord::Base
  has_many :decks, :dependent => :destroy
  has_many :matches, :through => :decks

  # attr_accessor :password, :password_confirmation

  attr_accessible :email, :first_name, :last_name, :uid, :username, :token, :password, :password_confirmation

  has_secure_password

	before_save { |user| user.email = email.downcase }
	before_save :create_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, 	presence: true,
  											uniqueness: { case_sensitive: false },
  								 			length: { maximum: 50 }

  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, unless: :facebook_user?

  validates :password, presence: true, length: { minimum: 4 }, unless: :facebook_user?
  validates :password_confirmation, presence: true, unless: :facebook_user?

  private

  def create_token
    self.token ||= SecureRandom.urlsafe_base64
  end

  def facebook_user?
  	self.uid.present?
  end

end
