require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:account) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
end
