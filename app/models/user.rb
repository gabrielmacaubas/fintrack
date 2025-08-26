class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :categories, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end
end

