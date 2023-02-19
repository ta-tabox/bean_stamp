class AddAddressToRoasters < ActiveRecord::Migration[6.1]
  def change
    add_column :roasters, :address, :string, null: false, default: ''
  end
end
