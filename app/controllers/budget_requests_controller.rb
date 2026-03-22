class BudgetRequestsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @budget_request = BudgetRequest.new(budget_request_params)

    if @budget_request.save
      BudgetRequestMailer.with(budget_request: @budget_request).new_request.deliver_now
      redirect_to budget_path, notice: "Solicitacao de orcamento enviada com sucesso. Nossa equipe retornara em breve."
    else
      flash.now[:alert] = "Nao foi possivel enviar sua solicitacao. Verifique os campos e tente novamente."
      render "pages/budget", status: :unprocessable_entity
    end
  end

  private

  def budget_request_params
    params.require(:budget_request).permit(
      :company_tax_id,
      :business_segment,
      :full_name,
      :phone,
      :email,
      :referral_source,
      :message
    )
  end
end