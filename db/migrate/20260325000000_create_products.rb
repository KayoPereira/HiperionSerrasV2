class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.integer :product_type, null: false
      t.text :name, null: false
      t.text :video_url

      t.timestamps
    end

    add_index :products, :product_type
  end
end
