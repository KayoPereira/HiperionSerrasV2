class CreateProductFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :product_faqs do |t|
      t.references :product, null: false, foreign_key: true
      t.text :question, null: false
      t.text :answer, null: false

      t.timestamps
    end
  end
end
