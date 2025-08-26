require 'rails_helper'

RSpec.describe "expenses/edit", type: :view do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:expense) {
    Expense.create!(
      user: user,
      category: category,
      amount: "9.99",
      description: "MyText",
      receipt_file: "MyString"
    )
  }

  before(:each) do
    assign(:expense, expense)
  end

  it "renders the edit expense form" do
    render

    assert_select "form[action=?][method=?]", expense_path(expense), "post" do

      assert_select "input[name=?]", "expense[user_id]"

      assert_select "input[name=?]", "expense[category_id]"

      assert_select "input[name=?]", "expense[amount]"

      assert_select "textarea[name=?]", "expense[description]"

      assert_select "input[name=?]", "expense[receipt_file]"
    end
  end
end


