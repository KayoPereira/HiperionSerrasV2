class Product < ApplicationRecord
  enum :product_type, {
    circular_saw: 0,
    band_saw: 1
  }

  enum :application_type, {
    ferrous_and_non_ferrous_metals: 0,
    wood: 1
  }

  has_rich_text :description
  has_many_attached :images
  has_many_attached :gallery
  has_one_attached :thumbnail
  has_one_attached :image_detail

  has_many :product_faqs, dependent: :destroy, inverse_of: :product

  accepts_nested_attributes_for :product_faqs,
    allow_destroy: true,
    reject_if: ->(attributes) { attributes["question"].blank? && attributes["answer"].blank? }

  validates :product_type, presence: true
  validates :application_type, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :thumbnail_presence

  before_validation :generate_slug, if: -> { slug.blank? || name_changed? }
  before_create :assign_display_order

  def to_param
    slug
  end

  def self.human_enum_name(enum_name, value)
    I18n.t("activerecord.enums.product.#{enum_name}.#{value}", default: value.to_s.humanize)
  end

  private

  def generate_slug
    base_slug = name.to_s.parameterize
    slug_candidate = base_slug
    counter = 2
    while Product.where.not(id: id).exists?(slug: slug_candidate)
      slug_candidate = "#{base_slug}-#{counter}"
      counter += 1
    end
    self.slug = slug_candidate
  end

  def assign_display_order
    return if display_order.present?

    max = Product
      .where(product_type: product_type, application_type: application_type)
      .maximum(:display_order) || 0
    self.display_order = max + 1
  end

  def thumbnail_presence
    return if thumbnail.attached?
    return if attachment_changes["thumbnail"].present?

    errors.add(:thumbnail, "deve ser enviada")
  end
end
