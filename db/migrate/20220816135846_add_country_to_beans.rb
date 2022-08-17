class AddCountryToBeans < ActiveRecord::Migration[6.1]
  def change
    add_reference :beans,
                  :country,
                  null: true,
                  default: 0,
                  foreign_key: {
                    to_table: :mst_countries,
                  }
  end
end
