class AddCompanyNameToBudgetRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :budget_requests, :company_name, :string
  end
end
