# app/models/message.rb
class Message < ApplicationRecord
  has_rich_text :content
end
