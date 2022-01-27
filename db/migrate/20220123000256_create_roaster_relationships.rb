class CreateRoasterRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :roaster_relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :roaster, null: false, foreign_key: true

      t.timestamps
      t.index %i[follower_id roaster_id], unique: true
    end
  end
end
