class CreateBeanTasteTags < ActiveRecord::Migration[6.1]
  def change
    create_table :bean_taste_tags do |t|
      t.references :bean, null: false, foreign_key: true
      t.references :mst_taste_tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :bean_taste_tags, %i[bean_id mst_taste_tag_id], unique: true
  end
end
