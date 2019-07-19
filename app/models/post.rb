class Post < ApplicationRecord
  validates :name,:description, presence: true

  belongs_to :user
  belongs_to :category
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
end
