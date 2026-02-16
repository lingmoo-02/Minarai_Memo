class Note < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :note_image, presence: true, on: :create
  validates :materials, presence: true, length: { maximum: 500 }
  validates :work_duration, presence: true, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 480
  }
  validates :reflection, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  belongs_to :team, optional: true
  belongs_to :tag, optional: true
  belongs_to :material, optional: true
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

  # 資材を配列として取得するメソッド
  def materials_array
    return [] if materials.blank?
    materials.split(/[、,]/).map(&:strip).reject(&:blank?)
  end

  # キーワード検索スコープ
  scope :search_by_keyword, ->(keyword) {
    return all if keyword.blank?

    sanitized_keyword = sanitize_sql_like(keyword.to_s)
    where(
      "title ILIKE :keyword OR reflection ILIKE :keyword OR materials ILIKE :keyword",
      keyword: "%#{sanitized_keyword}%"
    )
  }

  # タグフィルタスコープ
  scope :filter_by_tag, ->(tag_id) {
    return all if tag_id.blank?
    where(tag_id: tag_id)
  }

  # 日付範囲フィルタスコープ
  scope :created_between, ->(date_from, date_to) {
    scope = all
    scope = scope.where('created_at >= ?', date_from.beginning_of_day) if date_from.present?
    scope = scope.where('created_at <= ?', date_to.end_of_day) if date_to.present?
    scope
  }

  # 特定の日付（日本時間基準）で作成されたノートを取得するスコープ
  scope :created_on_date, ->(date) {
    return all if date.blank?

    # 日付を日本時間のタイムゾーンで解釈し、その日の開始時刻と終了時刻を取得
    start_time = date.in_time_zone('Tokyo').beginning_of_day
    end_time = date.in_time_zone('Tokyo').end_of_day

    where(created_at: start_time..end_time)
  }
end
