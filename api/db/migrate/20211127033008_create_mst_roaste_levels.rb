class CreateMstRoasteLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :mst_roaste_levels do |t|
      t.string :name

      t.timestamps
    end
  end
end
