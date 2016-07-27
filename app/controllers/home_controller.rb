class HomeController < ApplicationController
  def index
    if cookies[:account_pin].present?
      @account = Account.find_by!(pin: cookies[:account_pin])
    end
  end
end
