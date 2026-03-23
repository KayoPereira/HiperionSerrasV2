class Service < ApplicationRecord
  has_rich_text :details
  has_one_attached :image

  has_many :service_faqs, dependent: :destroy, inverse_of: :service

  accepts_nested_attributes_for :service_faqs,
    allow_destroy: true,
    reject_if: ->(attributes) { attributes["question"].blank? && attributes["answer"].blank? }

  validates :name, presence: true
  validates :description, presence: true
  validates :details, presence: true

  validate :image_must_be_attached

  private

  def image_must_be_attached
    errors.add(:image, "deve ser enviada") unless image.attached?
  end
end
