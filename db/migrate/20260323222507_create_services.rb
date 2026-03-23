class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.text :name, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
