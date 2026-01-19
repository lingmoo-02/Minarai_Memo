class Team < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :notes, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :owner_id, presence: true
end
