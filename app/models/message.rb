class Message < ApplicationRecord
  belongs_to :account

  validates :title, :body, presence: true
end
