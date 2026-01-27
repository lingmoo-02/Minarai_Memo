class Note < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :note_image, presence: true, on: :create
  validates :materials, presence: true, length: { maximum: 100 }
  validates :work_duration, presence: true, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 480
  }
  validates :reflection, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  belongs_to :team, optional: true
  belongs_to :tag, optional: true
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  mount_uploader :note_image, NoteImageUploader

  # 作業時間を「XX時間XX分」形式で表示
  def work_duration_formatted
    return nil unless work_duration.present?

    hours = work_duration / 60
    minutes = work_duration % 60

    if hours > 0 && minutes > 0
      "#{hours}時間#{minutes}分"
    elsif hours > 0
      "#{hours}時間"
    else
      "#{minutes}分"
    end
  end
end
