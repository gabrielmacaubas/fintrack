class Category < ApplicationRecord
  belongs_to :user
  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  
  validates :name, presence: true, uniqueness: { scope: :user_id }
end

