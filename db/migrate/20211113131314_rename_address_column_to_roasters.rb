class RenameAddressColumnToRoasters < ActiveRecord::Migration[6.1]
  def change
    rename_column :roasters, :address, :prefecture_code
  end
end
