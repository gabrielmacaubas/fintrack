json.extract! income, :id, :user_id, :category_id, :amount, :date, :description, :receipt_file, :created_at, :updated_at
json.url income_url(income, format: :json)
