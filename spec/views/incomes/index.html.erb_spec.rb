require 'rails_helper'

RSpec.describe "incomes/index", type: :view do
  before(:each) do
    assign(:incomes, Kaminari.paginate_array([create(:income), create(:income)]).page(1))
  end

  it "renders a list of incomes" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(Income.first.user.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(Income.first.category.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyString".to_s), count: 2
  end
end


