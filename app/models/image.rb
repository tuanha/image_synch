class Image < ActiveRecord::Base
  has_attached_file :file, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  validates :file,  presence: true

  belongs_to :user

  def link_download request
    request.protocol + request.host_with_port + file.url
  end
end
