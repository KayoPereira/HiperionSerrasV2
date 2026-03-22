class ContactMessagesController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      if deliver_contact_email
        redirect_to contact_path, notice: "Mensagem enviada com sucesso. Nossa equipe retornara em breve."
      else
        redirect_to contact_path, alert: "Recebemos sua mensagem, mas houve uma falha temporaria no envio do email. Nossa equipe vai verificar manualmente."
      end
    else
      flash.now[:alert] = "Nao foi possivel enviar sua mensagem. Verifique os campos e tente novamente."
      render "pages/contact", status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(
      :full_name,
      :phone,
      :email,
      :state,
      :city,
      :referral_source,
      :message
    )
  end

  def deliver_contact_email
    ContactMessageMailer.with(contact_message: @contact_message).new_message.deliver_now
    true
  rescue StandardError => error
    Rails.logger.error("Contact email delivery failed: #{error.class} - #{error.message}")
    false
  end
end
