class Material < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :team, optional: true
  has_many :notes, dependent: :nullify

  validates :name, presence: true, length: { maximum: 100 }
  validates :name, uniqueness: { scope: [:team_id, :user_id] }

  # 個人資材のみ取得
  scope :personal, -> { where(team_id: nil) }

  # チーム資材のみ取得
  scope :for_team, ->(team_id) { where(team_id: team_id) }
end
