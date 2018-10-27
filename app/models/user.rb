require 'openssl'
class User < ApplicationRecord

  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions, dependent: :destroy

  validates :username, :email, presence: true
  validates :username, :name, length: { maximum: 40, message: "не более 40 символов" }
  validates :username, :email, uniqueness: true
  validates :username, format: { with: /\A[a-z\d_]+\z/i, message: "неправильный" }
  validates :email, format: { with: /[а-яa-z\d\.]+@[а-яa-z\.]+/i, message: "неправильй" }
  validates :color, length: { maximum: 7 }, format: {with: /\A#[0-9a-f]{6}\z/i }, on: :update

  attr_accessor :password

  validates :password, presence: true, on: :create

  validates_confirmation_of :password

  before_validation :downcase_username

  def downcase_username
    if username.nil?
      username
    elsif
      self.username = username.downcase
    end
  end

  before_save :encrypt_password

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      self.password_hash = User.hash_to_string(
              OpenSSL::PKCS5.pbkdf2_hmac(
                      password, password_salt, ITERATIONS, DIGEST.length, DIGEST
              )
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    return nil unless user.present?

    hashed_password = User.hash_to_string(
                        OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt,ITERATIONS, DIGEST.length, DIGEST)
                      )
    return user if user.password_hash == hashed_password

    nil
  end

end
