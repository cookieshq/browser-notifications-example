class DevicesController < ApplicationController
  before_action :assign_and_authenticate_account

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

  def destroy
    device = @account.devices.find_by! endpoint: Base64.decode64(params[:id])

    if device.destroy
      head :no_content
    else
      render json: { errors: device.errors }, status: :unprocessable_entity
    end
  end

  private

  def device_params
    params.require(:device).permit(:endpoint, :p256dh, :auth)
  end
end
