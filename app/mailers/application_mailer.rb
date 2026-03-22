class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM_ADDRESS", "no-reply@hiperionserras.com.br")
  layout "mailer"
end
