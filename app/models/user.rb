class User < ApplicationRecord
  has_secure_password validations: false#, :unless => :facebook #facebookログインのためにfalseにしている 一番初めの形
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
                    length: {minimum: 6}, format: { with: VALID_EMAIL_REGEX }
  #validates :password, presence: true, length: { minimum: 6 }
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end

  #validates :password, presence: false#, :unless => :facebook #必要なのか

  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    name = auth[:info][:name]
    #email = "" if auth[:info][:email].nil?
    auth[:info][:email].nil? ? email = "" : email = auth[:info][:email]
    password_digest = "" if auth[:password_digest].nil?
    #image = auth[:info][:image]

    self.find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = name
      user.email = email
      user.password_digest = password_digest
      #user.image_url = image
    end
  end
#
#  before_save :email_downcase, unless: :uid?
#  validates :name, presence: true, unless: :uid?, length: { maximum: 50 }
#  validates :email, presence: true, unless: :uid?, length: { maximum: 255 },
#                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
#                    uniqueness: { case_sensitive: false }
#  has_secure_password validations: false
#
#  private
#
#  def email_downcase
#    self.email.downcase!
#  end
#end

#validates :password, presence: true, length: {minimum: 8}, on: :facebook_login
#
#  def self.from_omniauth(auth)
#    user = User.where('email = ?', auth.info.email).first
#    if user.blank?
#       user = User.new
#    end
#    user.uid   = auth.uid
#    user.username  = auth.info.name
#    user.email = auth.info.email
#    #user.oauth_token = auth.credentials.token
#    #user.oauth_expires_at = Time.at(auth.credentials.expires_at)
#    user
#  end
#validates :username, presence: true, unless: :uid? #他省略
#validates :email, presence: true, unless: :uid?
#has_secure_password validations: false
#validates :password, presence: true, unless: :uid?
#  def self.find_or_create_from_auth(auth)
#    provider = auth[:provider]
#    uid = auth[:uid]
#    name = auth[:info][:name]
#    #image = auth[:info][:image]
#    #必要に応じて情報追加してください

    #ユーザはSNSで登録情報を変更するかもしれので、毎回データベースの情報も更新する
#    self.find_or_create_by(provider: provider, uid: uid) do |user|
#      user.username = name
      #user.image_path = image
#  end


end
