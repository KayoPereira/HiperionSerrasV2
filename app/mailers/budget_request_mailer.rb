class BudgetRequestMailer < ApplicationMailer
  default from: "no-reply@hiperionserras.com.br"

  def new_request
    @budget_request = params[:budget_request]

    logo_path = Rails.root.join("app/assets/images/logo-nav-2x.png")
    if File.exist?(logo_path)
      attachments.inline["hiperion-logo.png"] = File.binread(logo_path)
    end

    mail(
      to: "contato@hiperionserras.com.br",
      subject: "[Site] Novo pedido de orcamento de #{@budget_request.full_name}"
    )
  end
end