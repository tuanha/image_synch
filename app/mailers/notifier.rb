class Notifier < ActionMailer::Base

  # ActionMailer::Base.smtp_settings = {address: 'localhost', port: 1025 }

  default from: '<info@dnews.com>'
  default to: '<no-reply@gmail.com>'

  def generate_reset_password_token user
    @user = user
    mail(:to => "#{@user.email}", :subject => "Reset password" )
  end

end
