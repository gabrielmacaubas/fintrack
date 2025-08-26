require 'rails_helper'

RSpec.describe "categories/show", type: "html.erb" do
  let(:category) { create(:category) }

  before(:each) do
    assign(:category, category)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{category.name}/)
    expect(rendered).to match(/#{category.description}/)
  end
end


