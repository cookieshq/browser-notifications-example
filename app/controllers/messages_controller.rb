class MessagesController < ApplicationController
  before_action :assign_and_authenticate_account

  def show
    @message = @account.messages.find(params[:id])
  end

  def create
    @message = @account.messages.build(message_params)

    Notifier.new(@message).notify_all_devices if @message.save

    respond_to do |format|
      format.js { render :create }
    end
  end

  private

  def message_params
    params.require(:message).permit(:title, :body)
  end
end
