class Obstacle < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :recommendations, dependent: :destroy
end
