class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :entries, dependent: :destroy
  has_many :gratefulnesses, dependent: :destroy
  has_many :obstacles, dependent: :destroy
end
