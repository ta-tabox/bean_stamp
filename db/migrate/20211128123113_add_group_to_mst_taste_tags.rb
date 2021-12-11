class AddGroupToMstTasteTags < ActiveRecord::Migration[6.1]
  def change
    add_reference :mst_taste_tags, :taste_group, null: false
  end
end
