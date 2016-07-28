require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  describe "POST #create" do
    let(:device_attributes) { attributes_for(:device).slice(:endpoint, :p256dh, :auth) }

    subject { post :create, params: { device: device_attributes } }

    context "with account cookied" do
      let(:account) { create(:account) }

      before(:each) do
        cookies[:account_pin] = account.pin
      end

      context "with no matching device already saved" do
        context "successful save" do
          it "creates a new device on account" do
            expect {
              subject
            }.to change { account.devices.count }.by(1)
          end

          it "returns 201 - Created status" do
            subject

            expect(controller).to respond_with(201)
          end

          it "returns device as JSON" do
            subject

            expect(response.body).to eq(account.devices.last.to_json)
          end

          it "sets user agent on device" do
            subject

            expect(account.devices.last.user_agent).to eq(request.user_agent)
          end
        end

        context "unsuccessful save" do
          let(:device_attributes) { attributes_for(:device).slice(:p256dh, :auth).merge(endpoint: "") }

          it "doesn't create a new device" do
            expect {
              subject
            }.not_to change(Device, :count)
          end

          it "returns 422 - Unprocessable Entity status" do
            subject

            expect(controller).to respond_with(422)
          end

          it "returns errors as JSON" do
            subject

            expect(JSON.parse response.body).to match "errors" => an_instance_of(Hash)
          end
        end
      end

      context "with matching device already saved" do
        let!(:existing_device) { create(:device, account: account, endpoint: device_attributes[:endpoint]) }

        it "doesn't create a new device" do
          expect {
            subject
          }.not_to change(Device, :count)
        end

        it "returns 200 - OK status" do
          subject

          expect(controller).to respond_with(200)
        end

        it "returns existing device as JSON" do
          subject

          expect(response.body).to eq(existing_device.to_json)
        end
      end
    end

    context "with no account cookied" do
      it "returns 403 - Forbidden" do
        subject

        expect(controller).to respond_with(403)
      end

      it "returns JSON error" do
        subject

        expect(JSON.parse response.body).to eq("errors" => { "base" => "You need to be connected to an account" })
      end
    end

    context "when account cookied but not found" do
      before(:each) do
        cookies[:account_pin] = "wrong"
      end

      it "returns 404 - Not Found" do
        subject

        expect(controller).to respond_with(404)
      end

      it "returns JSON error" do
        subject

        expect(JSON.parse response.body).to eq("errors" => { "base" => "Account not found" })
      end
    end
  end
end
