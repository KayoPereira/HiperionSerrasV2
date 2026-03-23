class CreateServiceFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :service_faqs do |t|
      t.references :service, null: false, foreign_key: true
      t.text :question, null: false
      t.text :answer, null: false

      t.timestamps
    end
  end
end
