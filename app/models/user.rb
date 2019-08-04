class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true,
                    length: {minimum: 6}, format: { with: VALID_EMAIL_REGEX }

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end

  validates :password, presence: false, on: :facebook_login

    def self.from_omniauth(auth)
        # emailの提供は必須とする
        user = User.where('email = ?', auth.info.email).first
      if user.blank?
        user = User.new
      end
    user.uid   = auth.uid
    user.name  = auth.info.name
    user.email = auth.info.email
    user.icon  = auth.info.image
    user.oauth_token      = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user
    end

end
