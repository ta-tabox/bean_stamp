class RemoveCountryFromBeans < ActiveRecord::Migration[6.1]
  def change
    remove_column :beans, :country, :string
  end
end
