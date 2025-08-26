json.extract! expense, :id, :user_id, :category_id, :amount, :date, :description, :receipt_file, :created_at, :updated_at
json.url expense_url(expense, format: :json)
