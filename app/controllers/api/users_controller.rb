class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?

  def forgot_password
    user = User.find_by_email(params[:email])

    respond_to do |format|
      if user.present?
        user.generate_reset_password_token
        Notifier.generate_reset_password_token( user ).deliver

        format.json { render json: { status: 1} }
      else
        format.json { render json: { status: 0 } }
      end
    end
  end

  def reset_password
    user = User.find_by(reset_password_token: params[:token])

    render json: { status: 0, message_errors: "Your token in invaild" } and return unless user.present?

    if user.reset_password(params[:password], params[:password_confirmation])
      user.clear_password_token
      render json: { status: 1 }
    else
      render json: { status: 0, message_errors: custom_errors(user)}
    end
  end

  protected

  def json_request?
    request.format.json?
  end
end
