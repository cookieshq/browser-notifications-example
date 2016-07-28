class DevicesController < ApplicationController
  before_action :assign_account

  def create
    existing_device = @account.devices.find_by(endpoint: device_params[:endpoint])

    if existing_device
      render json: existing_device, status: :ok and return
    end

    device = @account.devices.build(device_params.merge user_agent: request.user_agent)

    if device.save
      render json: device, status: :created
    else
      render json: { errors: device.errors }, status: :unprocessable_entity
    end
  end

  private

  def device_params
    params.require(:device).permit(:endpoint, :p256dh, :auth)
  end

  def assign_account
    if cookies[:account_pin].blank?
      render json: { errors: { base: "You need to be connected to an account" } }, status: :forbidden and return
    end

    @account = Account.find_by(pin: cookies[:account_pin])

    unless @account
      render json: { errors: { base: "Account not found" } }, status: :not_found and return
    end
  end
end
