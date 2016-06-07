class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    @url  = "#{ENV['APP_URL']}/#{locale}/users/#{user.activation_token}/activate"
    mail(to: user.email,
         subject: t('mail_subject.activation_needed'))
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email(user)
    @user = user
    @url  = "#{ENV['APP_URL']}/#{locale}/login"
    mail(to: user.email,
         subject: t('mail_subject.activation_success'))
  end

  def reset_password_email(user)
    @user = User.find user.id
    @url  = "#{ENV['APP_URL']}/#{locale}#{edit_password_reset_url(id: @user.reset_password_token, only_path: true)}"
    mail(to: user.email,
         subject: t('mail_subject.reset_password'))
  end
end
