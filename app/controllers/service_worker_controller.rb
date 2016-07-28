class ServiceWorkerController < ActionController::Metal
  include ActionController::DataStreaming

  def index
    filename = Rails.application.assets_manifest.assets["service-worker.js"]

    send_file Rails.root.join("public", "assets", filename).to_s, disposition: "inline"
  end

  private

  def send_file_headers!(options)
    super

    response.cache_control.replace({})
    headers["Cache-Control"] = "private, max-age=0, no-cache"

    headers.delete("Content-Disposition")
    headers.delete("Content-Transfer-Encoding")
  end
end
