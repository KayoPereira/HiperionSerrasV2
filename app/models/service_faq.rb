class ServiceFaq < ApplicationRecord
  belongs_to :service

  validates :question, presence: true
  validates :answer, presence: true
end
