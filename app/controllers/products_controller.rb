class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :circular_saw, :band_saw, :show ]
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def circular_saw
    @products = Product
      .where(product_type: :circular_saw)
      .includes(:product_faqs, :rich_text_description, images_attachments: :blob, image_detail_attachment: :blob)
      .order(created_at: :desc)
  end

  def band_saw
    @products = Product
      .where(product_type: :band_saw)
      .includes(:product_faqs, :rich_text_description, images_attachments: :blob, image_detail_attachment: :blob)
      .order(created_at: :desc)
  end

  def show
    @other_products = Product
      .where.not(id: @product.id)
      .includes(images_attachments: :blob)
      .order(created_at: :desc)
  end

  def new
    @product = Product.new
    build_minimum_faq
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to circular_saw_products_path, notice: "Produto criado com sucesso."
    else
      build_minimum_faq
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_minimum_faq
  end

  def update
    @product.images_attachments.where(id: params[:remove_images]).each(&:purge) if params[:remove_images].present?

    updated_params = product_params
    new_images = updated_params.delete(:images)

    if @product.update(updated_params)
      @product.images.attach(new_images) if new_images.present?
      redirect_to circular_saw_products_path, notice: "Produto atualizado com sucesso."
    else
      build_minimum_faq
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to circular_saw_products_path, notice: "Produto removido com sucesso."
  end

  private

  def set_product
    @product = Product.find_by!(slug: params[:id])
  end

  def product_params
    normalize_product_faqs_attribute_keys!

    params.require(:product).permit(
      :product_type,
      :application_type,
      :name,
      :description,
      :video_url,
      :image_detail,
      images: [],
      product_faqs_attributes: [ :id, :question, :answer, :_destroy ]
    )
  end

  def normalize_product_faqs_attribute_keys!
    product_payload = params[:product]
    return unless product_payload.respond_to?(:[])

    raw_faqs = product_payload[:product_faqs_attributes]
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

    product_payload[:product_faqs_attributes] = normalized
  end

  def build_minimum_faq
    @product.product_faqs.build if @product.product_faqs.empty?
  end
end
