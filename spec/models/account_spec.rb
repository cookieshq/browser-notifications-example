require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should have_many(:devices) }
  it { should have_many(:messages) }

  describe ".generate_pin" do
    it "sets 5-digit PIN" do
      account = create(:account)

      expect(account.pin).to have_attributes(length: 5)
    end

    context "with clashes" do
      before(:each) do
        method_count = 0

        allow(SecureRandom).to receive(:base58).and_wrap_original do |m, count|
          result = if method_count < 1
            "12345"
          else
            m.call(count)
          end

          method_count += 1
          result
        end

        create(:account, pin: "12345")
      end

      it "doesn't raise error" do
        expect {
          create(:account)
        }.not_to raise_error
      end
    end
  end
end
