class AddDitailsToBeans < ActiveRecord::Migration[6.1]
  def change
    add_column :beans, :country, :string, null: false, default: ''
    add_column :beans, :subregion, :string, null: false, default: ''
    add_column :beans, :farm, :string, null: false, default: ''
    add_column :beans, :variety, :string, null: false, default: ''
    add_column :beans, :elevation, :integer
    add_column :beans, :process, :string, null: false, default: ''
    add_column :beans, :cropped_at, :date
    add_column :beans, :describe, :text
    add_column :beans, :acidity, :integer
    add_column :beans, :flavor, :integer
    add_column :beans, :body, :integer
    add_column :beans, :bitterness, :integer
    add_column :beans, :sweetness, :integer
    add_index :beans, :country
  end
end
