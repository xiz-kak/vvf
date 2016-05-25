class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    @url  = "#{ENV['APP_URL']}/users/#{user.activation_token}/activate"
    mail(:to => user.email,
         :subject => "Welcome to Vin-Vin Funding")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email(user)
    @user = user
    @url  = "#{ENV['APP_URL']}/login"
    mail(:to => user.email,
         :subject => "Your account is now activated")
  end
end
