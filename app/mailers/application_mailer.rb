class ApplicationMailer < ActionMailer::Base
  default from: "info@vinvin-funding.com", bcc: "admin@vinvin-funding.com"
  layout 'mailer'
end
