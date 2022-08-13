class CreateMstCountries < ActiveRecord::Migration[6.1]
  def change
    create_table :mst_countries do |t|
      t.string :name

      t.timestamps
    end
  end
end
