class Obstacle < ApplicationRecord
  has_many :entries
  has_many :recommendations, dependent: :destroy

  validates :title, presence: true
  enum :status, {
    pending: 0,
    started: 1,
    completed: 2,
    cancelled: 3
  }
end
