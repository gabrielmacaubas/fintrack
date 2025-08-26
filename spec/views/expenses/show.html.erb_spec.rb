require 'rails_helper'

RSpec.describe "expenses/show", type: :view do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:expense) { create(:expense, user: user, category: category) }

  before(:each) do
    assign(:expense, expense)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{expense.user.id}/)
    expect(rendered).to match(/#{expense.category.id}/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyString/)
  end
end


