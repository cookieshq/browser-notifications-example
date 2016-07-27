# require 'active_support/core_ext/securerandom'

class Account < ApplicationRecord
  before_create :generate_pin, unless: :pin?

  private

  def generate_pin
    loop do
      new_pin = SecureRandom.base58(5)

      unless self.class.exists?(pin: new_pin)
        self.pin = new_pin
        break
      end
    end
  end
end
