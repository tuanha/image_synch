class Api::ImagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_request!

  def index
    render json: {user: current_user_api.email, images: current_user_api.images.select(:id, :file_file_name).map{ |image| image.as_json.merge(link: image.link_download(request))}}
  end

  def destroy
    image = current_user_api.images.find(params[:id]) rescue nil
    render json: { status: 0, message_errors: "Image not exits" } and return unless image.present?

    if image.destroy
      render json: { status: 1, message_success: 'success' }
    else
      render json: { status: 0, message_errors: image.errors.full_messages }
    end
  end

  def create
    image = current_user_api.images.new(file: params[:file])

    if image.save
      render json: {status: 1, message_success: 'success'}
    else
      render json: {status: 0, message_errors: image.errors.full_messages}
    end
  end

end
