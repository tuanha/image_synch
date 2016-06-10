class Api::ImagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_request!

  def index
    render json: {user: current_user_api.email, images: current_user_api.images.map{|image| image.link_download(request)}}
  end

  def create
    result = { status: "failed" }

    begin
      params[:image] = parse_image_data(params[:image]) if params[:image]
      item = Item.new
      item.image = params[:image]

      if item.save
        result[:status] = "success"
      end
    rescue Exception => e
      Rails.logger.error "#{e.message}"
    end

    render json: result.to_json
  ensure
    clean_tempfile
  end

  def parse_image_data(image_data)
    @tempfile = Tempfile.new('item_image')
    @tempfile.binmode
    @tempfile.write Base64.decode64(image_data[:content])
    @tempfile.rewind

    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: @tempfile,
      filename: image_data[:filename]
    )

    uploaded_file.content_type = image_data[:content_type]
    uploaded_file
  end

  def clean_tempfile
    if @tempfile
      @tempfile.close
      @tempfile.unlink
    end
  end
end
