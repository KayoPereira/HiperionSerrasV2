class CreateBudgetRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :budget_requests do |t|
      t.string :company_tax_id, null: false
      t.string :business_segment, null: false
      t.string :full_name, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :referral_source, null: false
      t.text :message, null: false

      t.timestamps
    end

    add_index :budget_requests, :email
    add_index :budget_requests, :created_at
  end
end