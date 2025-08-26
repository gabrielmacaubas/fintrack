require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /dashboard" do
    it "returns http success" do
      get "/dashboard"
      expect(response).to have_http_status(:success)
    end

    it "displays dashboard content" do
      get "/dashboard"
      expect(response.body).to include("Dashboard")
    end

    context "with financial data" do
      let(:category) { create(:category, user: user) }
      let!(:income) { create(:income, user: user, category: category, amount: 1000.0) }
      let!(:expense) { create(:expense, user: user, category: category, amount: 500.0) }

      it "calculates totals correctly" do
        get "/dashboard"
        expect(assigns(:total_incomes)).to eq(1000.0)
        expect(assigns(:total_expenses)).to eq(500.0)
        expect(assigns(:balance)).to eq(500.0)
      end

      it "shows recent transactions" do
        get "/dashboard"
        expect(assigns(:recent_transactions)).to include(income, expense)
      end
    end
  end

  describe "GET /dashboard without authentication" do
    before do
      sign_out user
    end

    it "redirects to sign in" do
      get "/dashboard"
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end

