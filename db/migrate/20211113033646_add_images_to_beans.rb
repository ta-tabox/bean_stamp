class AddImagesToBeans < ActiveRecord::Migration[6.1]
  def change
    add_column :beans, :images, :json
  end
end
