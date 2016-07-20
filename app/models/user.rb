class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :images, dependent: :destroy
  has_many :devices, dependent: :destroy

  def generate_reset_password_token
    password_token = loop do
      number_charset = %w{1 2 3 4 5 6 7 8 9}
      string_charset = %w{A C D E F G H J K M N P Q R T V W X Y}
      first_number_code = (1..2).map{ number_charset.to_a[rand(number_charset.size)] }.join("")
      char_code = (1..2).map{ string_charset.to_a[rand(string_charset.size)] }.join("")
      second_number_code = (1..2).map{ number_charset.to_a[rand(number_charset.size)] }.join("")
      random_token = "#{first_number_code}#{char_code}#{second_number_code}"
      break random_token unless self.class.exists?(reset_password_token: random_token)
    end

    self.update_without_password(reset_password_token: password_token, reset_password_sent_at: Time.now )
  end

  def clear_password_token
    self.update(reset_password_token: nil, reset_password_sent_at: nil)
  end

  def reset_password(password = nil , password_confirmation = nil)
    self.update(password: password, password_confirmation: password_confirmation)
  end

end
