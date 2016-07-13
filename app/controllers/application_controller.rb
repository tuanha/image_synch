class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  attr_reader :current_user_api

  protected

  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: 'Not Authenticated' }, status: :unauthorized
      return
    end
    @current_user_api = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: 'Not Authenticated' }, status: :unauthorized
  end

  def after_sign_in_path_for(resource_or_scope)
   "/admin"
  end

  private

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end
end
