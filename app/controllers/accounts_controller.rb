class AccountsController < ApplicationController
  def create
    account = Account.new

    if account.save
      cookies.permanent[:account_pin] = account.pin
      flash.notice = "Account created"
    else
      flash.alert = "Unable to create account"
    end

    redirect_to root_path
  end
end
