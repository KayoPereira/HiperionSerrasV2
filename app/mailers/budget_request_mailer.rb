class BudgetRequestMailer < ApplicationMailer
  def new_request
    @budget_request = params[:budget_request]

    logo_path = Rails.root.join("app/assets/images/logo-nav-2x.png")
    if File.exist?(logo_path)
      attachments.inline["hiperion-logo.png"] = File.binread(logo_path)
    end

    mail(
      to: ENV.fetch("MAILER_TO_ADDRESS", "contato@hiperionserras.com.br"),
      subject: "[Site] Novo pedido de orcamento de #{@budget_request.full_name}"
    )
  end
end