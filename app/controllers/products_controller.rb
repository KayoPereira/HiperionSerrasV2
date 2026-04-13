class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :circular_saw, :band_saw, :show ]
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def circular_saw
    @metals_products = Product
      .where(product_type: :circular_saw, application_type: :ferrous_and_non_ferrous_metals)
      .includes(:product_faqs, :rich_text_description, images_attachments: :blob, gallery_attachments: :blob, image_detail_attachment: :blob)
      .order(Arel.sql("display_order ASC NULLS LAST, created_at ASC"))
    @wood_products = Product
      .where(product_type: :circular_saw, application_type: :wood)
      .includes(:product_faqs, :rich_text_description, images_attachments: :blob, gallery_attachments: :blob, image_detail_attachment: :blob)
      .order(Arel.sql("display_order ASC NULLS LAST, created_at ASC"))
  end

  def band_saw
    @metals_products = Product
      .where(product_type: :band_saw, application_type: :ferrous_and_non_ferrous_metals)
      .includes(:product_faqs, :rich_text_description, images_attachments: :blob, gallery_attachments: :blob, image_detail_attachment: :blob)
      .order(Arel.sql("display_order ASC NULLS LAST, created_at ASC"))
    @wood_products = Product
      .where(product_type: :band_saw, application_type: :wood)
      .includes(:product_faqs, :rich_text_description, images_attachments: :blob, gallery_attachments: :blob, image_detail_attachment: :blob)
      .order(Arel.sql("display_order ASC NULLS LAST, created_at ASC"))
  end

  def show
    @other_products = Product
      .where.not(id: @product.id)
      .includes(images_attachments: :blob, gallery_attachments: :blob)
      .order(Arel.sql("display_order ASC NULLS LAST, created_at ASC"))
  end

  def reorder
    ids = Array(params[:ids]).map(&:to_i).select { |id| id > 0 }
    return head :bad_request if ids.empty?

    ids.each_with_index do |id, index|
      Product.where(id: id).update_all(display_order: index + 1)
    end

    head :ok
  end

  def new
    @product = Product.new
    build_minimum_faq
  end

  def create
    creation_params = product_params
    new_images = creation_params.delete(:images)
    new_gallery = creation_params.delete(:gallery)

    @product = Product.new(creation_params)

    if @product.save
      @product.images.attach(new_images) if new_images.present?
      @product.gallery.attach(new_gallery) if new_gallery.present?
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
    updated_params = product_params
    new_images = updated_params.delete(:images)
    new_gallery = updated_params.delete(:gallery)
    remove_thumbnail = ActiveModel::Type::Boolean.new.cast(params[:remove_thumbnail])
    remove_image_detail = ActiveModel::Type::Boolean.new.cast(params[:remove_image_detail])

    if remove_thumbnail && updated_params[:thumbnail].blank?
      @product.errors.add(:thumbnail, "deve ser enviada")
      build_minimum_faq
      return render :edit, status: :unprocessable_entity
    end

    if @product.update(updated_params)
      @product.images_attachments.where(id: params[:remove_images]).each(&:purge) if params[:remove_images].present?
      @product.gallery_attachments.where(id: params[:remove_gallery]).each(&:purge) if params[:remove_gallery].present?
      @product.image_detail.purge if remove_image_detail && updated_params[:image_detail].blank? && @product.image_detail.attached?
      @product.images.attach(new_images) if new_images.present?
      @product.gallery.attach(new_gallery) if new_gallery.present?
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
    @product = Product
      .includes(
        :product_faqs,
        :rich_text_description,
        images_attachments: :blob,
        gallery_attachments: :blob,
        thumbnail_attachment: :blob,
        image_detail_attachment: :blob
      )
      .find_by!(slug: params[:id] || params[:slug])
  end

  def product_params
    normalize_product_faqs_attribute_keys!

    params.require(:product).permit(
      :product_type,
      :application_type,
      :name,
      :description,
      :video_url,
      :thumbnail,
      :image_detail,
      images: [],
      gallery: [],
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
