class BudgetRequest < ApplicationRecord
  EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
  CNPJ_WEIGHTS = [ 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 ].freeze

  validates :company_tax_id, presence: true
  validates :business_segment, presence: true, length: { maximum: 120 }
  validates :full_name, presence: true, length: { maximum: 120 }
  validates :phone, presence: true, length: { maximum: 30 }
  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :state, presence: true, length: { maximum: 50 }
  validates :city, presence: true, length: { maximum: 80 }
  validates :referral_source, presence: true, length: { maximum: 80 }
  validates :message, presence: true, length: { maximum: 2000 }

  validate :company_tax_id_must_be_valid

  private

  def company_tax_id_must_be_valid
    digits = company_tax_id.to_s.gsub(/\D/, "")
    return errors.add(:company_tax_id, "deve conter 14 digitos") unless digits.length == 14
    return errors.add(:company_tax_id, "deve ser um CNPJ valido") if repeated_digits?(digits)
    return if valid_cnpj_digits?(digits)

    errors.add(:company_tax_id, "deve ser um CNPJ valido")
  end

  def repeated_digits?(digits)
    digits.chars.uniq.one?
  end

  def valid_cnpj_digits?(digits)
    base_digits = digits.chars.map(&:to_i)
    first_digit = cnpj_check_digit(base_digits.first(12), CNPJ_WEIGHTS)
    second_digit = cnpj_check_digit(base_digits.first(12) + [ first_digit ], [ 6 ] + CNPJ_WEIGHTS)

    first_digit == base_digits[12] && second_digit == base_digits[13]
  end

  def cnpj_check_digit(digits, weights)
    sum = digits.zip(weights).sum { |digit, weight| digit * weight }
    remainder = sum % 11

    remainder < 2 ? 0 : 11 - remainder
  end
end