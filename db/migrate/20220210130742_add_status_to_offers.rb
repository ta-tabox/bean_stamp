class AddStatusToOffers < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :status, :integer, null: false, default: 0
  end
end
