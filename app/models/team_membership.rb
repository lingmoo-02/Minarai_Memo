class TeamMembership < ApplicationRecord
  belongs_to :team
  belongs_to :user

  enum role: { apprentice: 0, master: 1, owner: 2 }

  validates :team_id, :user_id, :role, presence: true
  validates :team_id, uniqueness: { scope: :user_id }
end
