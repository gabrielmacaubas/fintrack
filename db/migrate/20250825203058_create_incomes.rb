class CreateIncomes < ActiveRecord::Migration[8.0]
  def change
    create_table :incomes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.decimal :amount
      t.date :date
      t.text :description
      t.string :receipt_file

      t.timestamps
    end
  end
end
