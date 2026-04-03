class BudgetRequestsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @budget_request = BudgetRequest.new(budget_request_params)

    if @budget_request.save
      if deliver_budget_email
        redirect_to budget_path, flash: { success_modal: "Solicitação de orçamento enviado com sucesso!" }
      else
        redirect_to budget_path, alert: "Recebemos sua solicitacao, mas houve uma falha temporaria no envio do email. Nossa equipe vai verificar manualmente."
      end
    else
      flash.now[:alert] = "Nao foi possivel enviar sua solicitacao. Verifique os campos e tente novamente."
      render "pages/budget", status: :unprocessable_entity
    end
  end

  private

  def budget_request_params
    params.require(:budget_request).permit(
      :company_tax_id,
      :company_name,
      :business_segment,
      :full_name,
      :phone,
      :email,
      :referral_source,
      :message
    )
  end

  def deliver_budget_email
    BudgetRequestMailer.with(budget_request: @budget_request).new_request.deliver_now
    true
  rescue StandardError => error
    Rails.logger.error("Budget email delivery failed: #{error.class} - #{error.message}")
    false
  end
end