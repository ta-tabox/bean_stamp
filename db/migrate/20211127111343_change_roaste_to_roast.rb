class ChangeRoasteToRoast < ActiveRecord::Migration[6.1]
  def change
    rename_table :mst_roaste_levels, :mst_roast_levels

    remove_reference :beans, :roaste_level

    add_reference :beans,
                  :roast_level,
                  null: false,
                  foreign_key: {
                    to_table: :mst_roast_levels,
                  }
  end
end
