class AddDisplayOrderToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :display_order, :integer
    add_index :products, [ :product_type, :application_type, :display_order ]
  end
end
