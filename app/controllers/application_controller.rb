class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def assign_and_authenticate_account
    if cookies[:account_pin].blank?
      account_error("You need to be connected to an account", status: :forbidden) and return
    end

    @account = Account.find_by(pin: cookies[:account_pin])

    unless @account
      account_error("Account not found", status: :not_found) and return
    end
  end

  def account_error(message, status: :ok)
    respond_to do |format|
      format.html { redirect_to root_path, alert: message }
      format.json { render json: { errors: { base: message } }, status: status }
      format.js do
        flash.alert = message
        render js: %Q{window.location = "#{j root_path}"}
      end
    end
  end
end
