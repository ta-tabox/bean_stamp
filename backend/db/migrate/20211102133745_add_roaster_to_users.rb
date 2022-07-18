class AddRoasterToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :roaster, foreign_key: true
  end
end
