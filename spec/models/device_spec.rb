require 'rails_helper'

RSpec.describe Device, type: :model do
  subject { build(:device) }

  it { should belong_to(:account) }

  it { should validate_presence_of(:endpoint) }
  it { should validate_uniqueness_of(:endpoint) }
end
