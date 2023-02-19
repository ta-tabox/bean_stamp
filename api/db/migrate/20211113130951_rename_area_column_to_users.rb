class RenameAreaColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :area, :prefecture_code
  end
end
