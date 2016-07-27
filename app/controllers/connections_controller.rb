class ConnectionsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    account = Account.find_by(pin: account_params[:pin])

    if account.present?
      cookies.permanent[:account_pin] = account.pin
      redirect_to root_path
    else
      @account = account_with_error
      render :new
    end
  end

  private

  def account_params
    params.require(:account).permit(:pin)
  end

  def account_with_error
    Account.new.tap do |account|
      account.errors.add(:pin, "not found")
    end
  end
end
