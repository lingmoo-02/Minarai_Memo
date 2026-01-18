class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  has_many :notes, dependent: :nullify
end
