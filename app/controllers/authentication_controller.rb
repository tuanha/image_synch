class AuthenticationController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def authenticate_user
    user = User.find_by(email: params[:email])
    if user && user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: {status: 0, errors: 'Invalid Username/Password'}, status: :unauthorized
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
