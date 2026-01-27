class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :note

  validates :user_id, :note_id, presence: true
  validates :user_id, uniqueness: { scope: :note_id }
end
