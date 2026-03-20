class ContactMessage < ApplicationRecord
  EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP

  validates :full_name, presence: true, length: { minimum: 3, maximum: 120 }
  validates :phone, presence: true, length: { minimum: 8, maximum: 30 }
  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :state, presence: true, length: { maximum: 50 }
  validates :city, presence: true, length: { maximum: 80 }
  validates :referral_source, presence: true, length: { maximum: 80 }
  validates :message, presence: true, length: { minimum: 10, maximum: 2000 }
end
