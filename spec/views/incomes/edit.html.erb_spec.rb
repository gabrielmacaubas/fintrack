require 'rails_helper'

RSpec.describe "incomes/edit", type: :view do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:income) {
    Income.create!(
      user: user,
      category: category,
      amount: "9.99",
      description: "MyText",
      receipt_file: "MyString"
    )
  }

  before(:each) do
    assign(:income, income)
  end

  it "renders the edit income form" do
    render

    assert_select "form[action=?][method=?]", income_path(income), "post" do

      assert_select "input[name=?]", "income[user_id]"

      assert_select "input[name=?]", "income[category_id]"

      assert_select "input[name=?]", "income[amount]"

      assert_select "textarea[name=?]", "income[description]"

      assert_select "input[name=?]", "income[receipt_file]"
    end
  end
end


