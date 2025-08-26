class RenameCategoryTypeColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :categories, :type, :category_type
  end
end


