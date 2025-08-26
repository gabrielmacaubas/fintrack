require 'rails_helper'

RSpec.describe "Incomes", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }
  let(:valid_attributes) {
    {
      amount: 100.0,
      date: Date.current,
      description: "Salário",
      category_id: category.id
    }
  }
  let(:invalid_attributes) {
    {
      amount: -100.0,
      date: nil,
      description: "",
      category_id: category.id
    }
  }

  before do
    sign_in user
  end

  describe "GET /incomes" do
    it "returns http success" do
      get incomes_path
      expect(response).to have_http_status(:success)
    end

    it "displays user's incomes only" do
      other_user = create(:user, email: 'other@example.com', username: 'other')
      other_category = create(:category, user: other_user)
      user_income = create(:income, user: user, category: category)
      other_income = create(:income, user: other_user, category: other_category)

      get incomes_path
      expect(assigns(:incomes)).to include(user_income)
      expect(assigns(:incomes)).not_to include(other_income)
    end
  end

  describe "GET /incomes/:id" do
    let(:income) { create(:income, user: user, category: category) }

    it "returns http success" do
      get income_path(income)
      expect(response).to have_http_status(:success)
    end

    it "prevents access to other user's income" do
      other_user = create(:user, email: 'other@example.com', username: 'other')
      other_category = create(:category, user: other_user)
      other_income = create(:income, user: other_user, category: other_category)

      expect {
        get income_path(other_income)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET /incomes/new" do
    it "returns http success" do
      get new_income_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /incomes" do
    context "with valid parameters" do
      it "creates a new Income" do
        expect {
          post incomes_path, params: { income: valid_attributes }
        }.to change(Income, :count).by(1)
      end

      it "assigns the income to current user" do
        post incomes_path, params: { income: valid_attributes }
        expect(Income.last.user).to eq(user)
      end

      it "redirects to the created income" do
        post incomes_path, params: { income: valid_attributes }
        expect(response).to redirect_to(Income.last)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Income" do
        expect {
          post incomes_path, params: { income: invalid_attributes }
        }.to change(Income, :count).by(0)
      end

      it "renders the new template" do
        post incomes_path, params: { income: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /incomes/:id" do
    let(:income) { create(:income, user: user, category: category) }
    let(:new_attributes) { { amount: 200.0, description: "Bonus" } }

    context "with valid parameters" do
      it "updates the requested income" do
        patch income_path(income), params: { income: new_attributes }
        income.reload
        expect(income.amount).to eq(200.0)
        expect(income.description).to eq("Bonus")
      end

      it "redirects to the income" do
        patch income_path(income), params: { income: new_attributes }
        expect(response).to redirect_to(income)
      end
    end

    context "with invalid parameters" do
      it "renders the edit template" do
        patch income_path(income), params: { income: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /incomes/:id" do
    let!(:income) { create(:income, user: user, category: category) }

    it "destroys the requested income" do
      expect {
        delete income_path(income)
      }.to change(Income, :count).by(-1)
    end

    it "redirects to the incomes list" do
      delete income_path(income)
      expect(response).to redirect_to(incomes_path)
    end
  end
end
