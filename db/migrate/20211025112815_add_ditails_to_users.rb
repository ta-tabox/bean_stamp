class AddDitailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, null: false, default: ''
    add_column :users, :area, :string, default: ''
    add_column :users, :describe, :text
  end
end
