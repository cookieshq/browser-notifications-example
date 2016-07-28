class HomeController < ApplicationController
  def index
    if cookies[:account_pin].present?
      @account = Account.find_by!(pin: cookies[:account_pin])
      @message = @account.messages.build
    end
  end

  def manifest
    manifest_hash = {
      name: "Browser notifications example",
      gcm_sender_id: ENV["GCM_SENDER_ID"]
    }

    render json: manifest_hash
  end

  def service_worker
    filename = Rails.application.assets_manifest.assets["service-worker.js"]

    send_file Rails.root.join("public", "assets", filename).to_s, disposition: "inline"
  end

  private

  def send_file_headers!(options)
    super

    headers["Cache-Control"] = "private, max-age=0, no-cache"

    headers.delete("Content-Disposition")
    headers.delete("Content-Transfer-Encoding")
  end
end
