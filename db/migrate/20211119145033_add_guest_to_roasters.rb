class AddGuestToRoasters < ActiveRecord::Migration[6.1]
  def change
    add_column :roasters, :guest, :boolean, default: false
  end
end
