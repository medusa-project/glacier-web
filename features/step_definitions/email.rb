Then(/^the admin should receive an email with subject '(.*)' matching '(.*)'$/) do |subject, message_text|
  open_email(Settings.email.admin)
  email = current_emails.detect{|email| email.subject == subject}
  expect(email).to be_truthy
  expect(email.body).to match(message_text)
end