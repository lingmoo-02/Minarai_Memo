class Note < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  belongs_to :team, optional: true
  belongs_to :tag, optional: true

  mount_uploader :note_image, NoteImageUploader
end
