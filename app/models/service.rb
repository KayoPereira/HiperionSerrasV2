class Service < ApplicationRecord
  has_rich_text :details
  has_one_attached :image
  has_one_attached :thumbnail

  has_many :service_faqs, dependent: :destroy, inverse_of: :service

  accepts_nested_attributes_for :service_faqs,
    allow_destroy: true,
    reject_if: ->(attributes) { attributes["question"].blank? && attributes["answer"].blank? }

  validates :name, presence: true
  validates :details, presence: true
  validate :thumbnail_presence

  private

  def thumbnail_presence
    return if thumbnail.attached?
    return if attachment_changes["thumbnail"].present?

    errors.add(:thumbnail, "deve ser enviada")
  end
end
