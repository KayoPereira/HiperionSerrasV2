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

  before_validation :generate_slug, if: -> { slug.blank? || name_changed? }

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
end
