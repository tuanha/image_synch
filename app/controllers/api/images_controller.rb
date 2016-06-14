class Api::ImagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_request!

  def index
    render json: {user: current_user_api.email, images: current_user_api.images.map{|image| image.link_download(request)}}
  end

  def create
    image = current_user_api.images.new(file: params[:file])

    if image.save
      render json: {status: 0, message: 'success'}
    else
      render json: {status: 1, message: image.errors.full_messages}
    end
  end

end
