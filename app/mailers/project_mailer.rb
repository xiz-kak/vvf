class ProjectMailer < ApplicationMailer
  def apply_email_to_creator(project)
    @project = project
    @user = project.user
    mail(to: @user.email,
         subject: t('mail_subject.apply_email_to_creator'))
  end

  def apply_email_to_admin(project)
    @project = project
    @user = project.user
    @review_url  = "#{ENV['APP_URL']}#{project_url(id: project.id, only_path: true)}"

    mail(to: 'info@vinvin-funding.com',
         subject: t('mail_subject.apply_email_to_admin'))
  end
end
