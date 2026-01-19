class Tag < ApplicationRecord
  belongs_to :team, optional: true
  has_many :notes, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }
  validates :name, uniqueness: { scope: :team_id }
end
