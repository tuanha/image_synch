class AuthenticationController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def authenticate_user
    user = User.find_for_database_authentication(email: params[:email])
    if user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: {errors: 'Invalid Username/Password', status: 0}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user and user.id
    { status: 1,
      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email}
    }
  end
end
