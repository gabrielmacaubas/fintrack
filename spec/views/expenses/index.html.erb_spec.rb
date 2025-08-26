require 'rails_helper'

RSpec.describe "expenses/index", type: :view do
  before(:each) do
    assign(:expenses, Kaminari.paginate_array([create(:expense), create(:expense)]).page(1))
  end

  it "renders a list of expenses" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(Expense.first.user.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(Expense.first.category.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: '2'
    assert_select cell_selector, text: Regexp.new("MyString".to_s), count: 2
  end
end


