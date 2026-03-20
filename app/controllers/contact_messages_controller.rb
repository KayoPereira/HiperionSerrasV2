class ContactMessagesController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      ContactMessageMailer.with(contact_message: @contact_message).new_message.deliver_now
      redirect_to contact_path, notice: "Mensagem enviada com sucesso. Nossa equipe retornara em breve."
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
end
