class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :obstacle, optional: true
  validates :content, presence: true
  has_rich_text :rich_body
end
