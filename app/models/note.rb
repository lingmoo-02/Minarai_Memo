class Note < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  has_many :note_tags, dependent: :destroy
  has_many :tags, through: :note_tags

  mount_uploader :note_image, NoteImageUploader
end
