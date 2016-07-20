class Api::DevicesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_request!

  def create
    device = current_user_api.devices.new(token: params[:token])

    if device.save
      render json: {status: 1, message_success: 'success'}
    else
      render json: {status: 0, message_errors: device.errors.full_messages}
    end
  end

end
