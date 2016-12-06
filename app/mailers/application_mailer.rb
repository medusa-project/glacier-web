class ApplicationMailer < ActionMailer::Base
  default from: Settings.email.no_reply
  layout 'mailer'
end
