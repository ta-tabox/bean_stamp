class ChangeRoastLevelIdNullTrueToBeans < ActiveRecord::Migration[6.1]
  def up
    change_column :beans, :roast_level_id, :bigint, null: true, default: 0
  end

  def down
    change_column :beans, :roast_level_id, :bigint, null: false, default: nil
  end
end
