class CreateBeanImages < ActiveRecord::Migration[6.1]
  def change
    create_table :bean_images do |t|
      t.string :image
      t.references :bean, null: false, foreign_key: true

      t.timestamps
    end
  end
end
