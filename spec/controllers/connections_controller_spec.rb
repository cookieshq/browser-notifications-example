require 'rails_helper'

RSpec.describe ConnectionsController, type: :controller do
  describe "POST #create" do
    subject { post :create, params: { account: { pin: pin } } }

    context "when account exists" do
      let(:account) { create(:account) }
      let(:pin)     { account.pin }

      it { should redirect_to(root_path) }

      it "sets a cookie for the account PIN" do
        subject

        expect(cookies[:account_pin]).to eq(pin)
      end
    end

    context "when account doesn't exist" do
      render_views

      let(:pin) { "wrong" }

      it "renders error" do
        subject

        expect(response.body).to match(/not found/i)
      end

      it "doesn't sets a cookie for the account PIN" do
        subject

        expect(cookies[:account_pin]).to be_nil
      end
    end
  end
end
