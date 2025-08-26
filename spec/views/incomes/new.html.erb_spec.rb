require 'rails_helper'

RSpec.describe "incomes/new", type: :view do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  before(:each) do
    assign(:income, Income.new(
      user: user,
      category: category,
      amount: "9.99",
      description: "MyText",
      receipt_file: "MyString"
    ))
  end

  it "renders new income form" do
    render

    assert_select "form[action=?][method=?]", incomes_path, "post" do

      assert_select "input[name=?]", "income[user_id]"

      assert_select "input[name=?]", "income[category_id]"

      assert_select "input[name=?]", "income[amount]"

      assert_select "textarea[name=?]", "income[description]"

      assert_select "input[name=?]", "income[receipt_file]"
    end
  end
end


