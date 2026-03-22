class ContactMessageMailer < ApplicationMailer
  def new_message
    @contact_message = params[:contact_message]

    logo_path = Rails.root.join("app/assets/images/logo-nav-2x.png")
    if File.exist?(logo_path)
      attachments.inline["hiperion-logo.png"] = File.binread(logo_path)
    end

    mail(
      to: ENV.fetch("MAILER_TO_ADDRESS", "contato@hiperionserras.com.br"),
      subject: "[Site] Novo contato de #{@contact_message.full_name}"
    )
  end
end
