class CreateWants < ActiveRecord::Migration[6.1]
  def change
    create_table :wants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :offer, null: false, foreign_key: true
      t.datetime :receipted_at

      t.timestamps
      t.index %i[user_id offer_id], unique: true
    end
  end
end
