class Image < ActiveRecord::Base
  has_attached_file :file, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  validates :file,  presence: true

  belongs_to :user

  after_create :send_notify

  def link_download request
    request.protocol + request.host_with_port + file.url
  end

  def send_notify
    gcm = GCM.new(ENV["GCM_API_KEY"])
    registration_ids = self.user.devices.pluck(:token)
    gcm.send(registration_ids, {data: {message: "Bạn có ảnh mới"}})
  end
end
