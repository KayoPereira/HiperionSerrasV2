class AddApplicationTypeToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :application_type, :integer, null: false, default: 0
    add_index :products, :application_type
  end
end
