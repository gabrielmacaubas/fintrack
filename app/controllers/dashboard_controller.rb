class DashboardController < ApplicationController
  def index
    authorize! :read, :dashboard

    @total_incomes = current_user.incomes.sum(:amount)
    @total_expenses = current_user.expenses.sum(:amount)
    @balance = @total_incomes - @total_expenses

    @incomes_by_category = current_user.incomes.joins(:category).group("categories.name").sum(:amount)
    @expenses_by_category = current_user.expenses.joins(:category).group("categories.name").sum(:amount)

    @recent_transactions = (current_user.incomes.all + current_user.expenses.all).sort_by(&:date).reverse.take(10)
  end
end

