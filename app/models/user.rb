class User < ActiveRecord::Base
  attr_accessible :email, :last_name, :first_name, :password, :password_confirmation, :user_type, :avatar, :status, :created_at, :updated_at
  has_many :credits
  has_many :games
  has_many :pools
  has_many :players
  has_many :prizes
  has_many :addresses

  has_secure_password #Rails 3 helper method to require/encrpypt password and password confirmation using password digest

  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def self.search(search)
    if search
      where('first_name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  require 'carrierwave/orm/activerecord'
    mount_uploader :avatar, AvatarUploader

  #logic

  

  private

  def create_remember_token
  	 self.remember_token = SecureRandom.urlsafe_base64
  end
  
end