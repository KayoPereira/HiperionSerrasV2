class ServicesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  before_action :set_service, only: [ :show, :edit, :update, :destroy ]

  def index
    @services = Service
      .includes(:service_faqs, :rich_text_details, thumbnail_attachment: :blob, image_attachment: :blob)
      .order(created_at: :asc)
  end

  def show
    @other_services = Service
      .where.not(id: @service.id)
      .includes(thumbnail_attachment: :blob, image_attachment: :blob)
      .order(created_at: :asc)
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
    remove_thumbnail = ActiveModel::Type::Boolean.new.cast(params[:remove_thumbnail])
    remove_image = ActiveModel::Type::Boolean.new.cast(params[:remove_image])

    if remove_thumbnail && service_params[:thumbnail].blank?
      @service.errors.add(:thumbnail, "deve ser enviada")
      build_minimum_faq
      return render :edit, status: :unprocessable_entity
    end

    if @service.update(service_params)
      @service.thumbnail.purge if remove_thumbnail && service_params[:thumbnail].blank? && @service.thumbnail.attached?
      @service.image.purge if remove_image && service_params[:image].blank? && @service.image.attached?
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
    @service = Service
      .includes(
        :service_faqs,
        :rich_text_details,
        thumbnail_attachment: :blob,
        image_attachment: :blob
      )
      .find(params[:id])
  end

  def service_params
    normalize_service_faqs_attribute_keys!

    params.require(:service).permit(
      :name,
      :description,
      :details,
      :thumbnail,
      :image,
      service_faqs_attributes: [ :id, :question, :answer, :_destroy ]
    )
  end

  def normalize_service_faqs_attribute_keys!
    service_payload = params[:service]
    return unless service_payload.respond_to?(:[])

    raw_faqs = service_payload[:service_faqs_attributes]
    return unless raw_faqs.respond_to?(:to_h)

    faqs_hash = raw_faqs.respond_to?(:to_unsafe_h) ? raw_faqs.to_unsafe_h : raw_faqs.to_h
    return if faqs_hash.keys.all? { |key| key.to_s.match?(/\A\d+\z/) }

    normalized = {}
    next_index = 0

    faqs_hash.each do |key, value|
      key_str = key.to_s

      if key_str.match?(/\A\d+\z/) && !normalized.key?(key_str)
        normalized[key_str] = value
        next_index = [ next_index, key_str.to_i + 1 ].max
      else
        next_index += 1 while normalized.key?(next_index.to_s)
        normalized[next_index.to_s] = value
        next_index += 1
      end
    end

    service_payload[:service_faqs_attributes] = normalized
  end

  def build_minimum_faq
    @service.service_faqs.build if @service.service_faqs.empty?
  end
end
