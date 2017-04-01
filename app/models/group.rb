class Group < ApplicationRecord
  belongs_to :user
  has_many :posts
  validates :title, presence: true
  has_may :group_relationships
  has_many :members, through: :group_relationships, source: :user
end
