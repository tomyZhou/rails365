class User < ActiveRecord::Base
  ALLOW_LOGIN_CHARS_REGEXP = /\A[A-Za-z0-9\-\_\.]+\z/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async, authentication_keys: [:login]
  devise :omniauthable, omniauth_providers: [:github]

  validate :validate_username
  validates :username, format: { with: ALLOW_LOGIN_CHARS_REGEXP, message: '只允许数字、大小写字母和下划线' },
                       length: { in: 3..20 }, presence: true,
                       uniqueness: { case_sensitive: true }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = "from_github_#{auth.info.email}"
      user.username = Devise.friendly_token[0, 20]
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def self.serialize_from_session(key, salt)
    Rails.cache.fetch "current_user_#{key}" do
      super
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_hash).first
    end
  end

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def super_admin?
    Settings.admin_emails.include?(email)
  end
end
