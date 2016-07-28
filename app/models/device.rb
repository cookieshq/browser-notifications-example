class Device < ApplicationRecord
  belongs_to :account

  validates :endpoint, presence: true, uniqueness: true
end
