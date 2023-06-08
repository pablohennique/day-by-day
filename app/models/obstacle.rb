class Obstacle < ApplicationRecord
  has_many :entries
  has_many :recommendations, dependent: :destroy

  validates :title, presence: true
end
