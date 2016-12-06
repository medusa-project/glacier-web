class ErrorMailer < ApplicationMailer
  default subject: 'Glacier error'

  def error(message)
    @message = message.to_s
    mail to: Settings.email.admin
  end
end
