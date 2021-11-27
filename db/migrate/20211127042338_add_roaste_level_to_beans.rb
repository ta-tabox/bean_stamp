class AddRoasteLevelToBeans < ActiveRecord::Migration[6.1]
  def change
    add_reference :beans,
                  :roaste_level,
                  null: false,
                  foreign_key: {
                    to_table: :mst_roaste_levels,
                  }
  end
end
