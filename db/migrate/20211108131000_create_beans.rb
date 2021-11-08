class CreateBeans < ActiveRecord::Migration[6.1]
  def change
    create_table :beans do |t|
      t.string :name
      t.references :roaster, null: false, foreign_key: true

      t.timestamps
    end
  end
end
