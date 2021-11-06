class AddImageToRoasters < ActiveRecord::Migration[6.1]
  def change
    add_column :roasters, :image, :string
  end
end
