class Obstacle < ApplicationRecord
  has_many :entries
  has_many :recommendations, dependent: :destroy
end
