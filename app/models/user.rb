class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true,
                    length: {minimum: 6}, format: { with: VALID_EMAIL_REGEX }


  has_many :posts, dependent: :destroy
end
