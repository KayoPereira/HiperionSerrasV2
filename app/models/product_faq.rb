class ProductFaq < ApplicationRecord
  belongs_to :product

  has_rich_text :answer

  validates :question, presence: true
  validates :answer, presence: true
end
