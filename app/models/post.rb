class Post < ApplicationRecord
  validates :name,:description, presence: true

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
end
