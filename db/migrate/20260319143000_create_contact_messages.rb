class CreateContactMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_messages do |t|
      t.string :full_name, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :state, null: false
      t.string :city, null: false
      t.string :referral_source, null: false
      t.text :message, null: false

      t.timestamps
    end

    add_index :contact_messages, :email
    add_index :contact_messages, :created_at
  end
end
