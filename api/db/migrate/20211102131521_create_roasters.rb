class CreateRoasters < ActiveRecord::Migration[6.1]
  def change
    create_table :roasters do |t|
      t.string :name, null: false, default: ''
      t.string :phone_number, null: false, default: ''
      t.string :address, null: false, default: ''
      t.text :describe

      t.timestamps
    end
    add_index :roasters, :address
  end
end
