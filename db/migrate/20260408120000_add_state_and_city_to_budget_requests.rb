class AddStateAndCityToBudgetRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :budget_requests, :state, :string
    add_column :budget_requests, :city, :string
  end
end