class ServiceFaq < ApplicationRecord
  belongs_to :service

  has_rich_text :answer

  validates :question, presence: true
  validates :answer, presence: true
end
