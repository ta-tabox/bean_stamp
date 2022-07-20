class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.references :bean, null: false, foreign_key: true
      t.date :ended_at, null: false
      t.date :roasted_at, null: false
      t.date :receipt_started_at, null: false
      t.date :receipt_ended_at, null: false
      t.integer :price, null: false
      t.integer :weight, null: false
      t.integer :amount, null: false
      t.timestamps
    end
    add_index :offers, %i[bean_id created_at ended_at]
  end
end
