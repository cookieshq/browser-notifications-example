require 'rails_helper'

RSpec.describe Device, type: :model do
  it { should belong_to(:account) }
end
