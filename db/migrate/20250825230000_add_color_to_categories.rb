class AddColorToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :color, :string, default: "#375a7f" unless column_exists?(:categories, :color)
  end
end
