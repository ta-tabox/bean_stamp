class RemoveImagesFromBeans < ActiveRecord::Migration[6.1]
  def up
    remove_column :beans, :images, :json
  end

  def down
    add_column :beans, :images, :json
  end
end
