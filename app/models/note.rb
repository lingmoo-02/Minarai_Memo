class Note < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  validates :note_image, presence: true, on: :create

  belongs_to :user
  belongs_to :team, optional: true
  belongs_to :tag, optional: true
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  mount_uploader :note_image, NoteImageUploader
end
