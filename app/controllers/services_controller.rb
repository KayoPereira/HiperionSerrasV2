class ServicesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  before_action :set_service, only: [ :show, :edit, :update, :destroy ]

  def index
    @services = Service
      .includes(:service_faqs, :rich_text_details, image_attachment: :blob)
      .order(created_at: :desc)
  end

  def show
    @other_services = Service
      .where.not(id: @service.id)
      .includes(image_attachment: :blob)
      .order(created_at: :desc)
  end

  def new
    @service = Service.new
    build_minimum_faq
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to services_path, notice: "Servico criado com sucesso."
    else
      build_minimum_faq
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_minimum_faq
  end

  def update
    if @service.update(service_params)
      redirect_to services_path, notice: "Servico atualizado com sucesso."
    else
      build_minimum_faq
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    redirect_to services_path, notice: "Servico removido com sucesso."
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(
      :name,
      :description,
      :details,
      :image,
      service_faqs_attributes: [ :id, :question, :answer, :_destroy ]
    )
  end

  def build_minimum_faq
    @service.service_faqs.build if @service.service_faqs.empty?
  end
end
