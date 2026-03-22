require "test_helper"

class BudgetRequestTest < ActiveSupport::TestCase
  def valid_attributes
    {
      company_tax_id: "11.444.777/0001-61",
      business_segment: "Metalurgia",
      full_name: "Carlos Pereira",
      phone: "(19) 99999-9999",
      email: "carlos@example.com",
      referral_source: "Google",
      message: "Precisamos de um orcamento para serras industriais."
    }
  end

  test "is valid with a valid cnpj" do
    budget_request = BudgetRequest.new(valid_attributes)

    assert budget_request.valid?
  end

  test "is invalid with an invalid cnpj checksum" do
    budget_request = BudgetRequest.new(valid_attributes.merge(company_tax_id: "11.444.777/0001-62"))

    assert_not budget_request.valid?
    assert_includes budget_request.errors[:company_tax_id], "deve ser um CNPJ valido"
  end

  test "is invalid with repeated digits cnpj" do
    budget_request = BudgetRequest.new(valid_attributes.merge(company_tax_id: "11.111.111/1111-11"))

    assert_not budget_request.valid?
    assert_includes budget_request.errors[:company_tax_id], "deve ser um CNPJ valido"
  end
end