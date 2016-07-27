require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  describe "POST #create" do
    subject { post :create }

    context "saving succeeds" do
      it { should redirect_to(root_path) }

      it "creates a new account" do
        expect {
          subject
        }.to change(Account, :count).by(1)
      end

      it "sets a flash notice" do
        subject

        expect(controller).to set_flash[:notice]
      end

      it "sets a cookie for the account PIN" do
        subject

        expect(cookies[:account_pin]).to be_present
      end
    end

    context "saving fails" do
      before(:each) do
        account = instance_double("Account", save: false)
        allow(Account).to receive(:new).and_return(account)
      end

      it { should redirect_to(root_path) }

      it "doesn't create a new account" do
        expect {
          subject
        }.not_to change(Account, :count)
      end

      it "sets a flash alert" do
        subject

        expect(controller).to set_flash[:alert]
      end

      it "doesn't set a cookie for the account PIN" do
        subject

        expect(cookies[:account_pin]).to be_nil
      end
    end
  end
end
