class HomeController < ApplicationController
  def index
    if cookies[:account_pin].present?
      @account = Account.find_by!(pin: cookies[:account_pin])
    end
  end

  def manifest
    manifest_hash = {
      name: "Browser notifications example",
      gcm_sender_id: ENV["GCM_SENDER_ID"]
    }

    render json: manifest_hash
  end
end
