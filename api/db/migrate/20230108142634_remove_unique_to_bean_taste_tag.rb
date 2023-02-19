class RemoveUniqueToBeanTasteTag < ActiveRecord::Migration[6.1]
  def up
    remove_index :bean_taste_tags, %i[bean_id mst_taste_tag_id]
    add_index :bean_taste_tags, %i[bean_id mst_taste_tag_id]
  end

  def down
    remove_index :bean_taste_tags, %i[bean_id mst_taste_tag_id]
    add_index :bean_taste_tags, %i[bean_id mst_taste_tag_id], unique: true
  end
end
