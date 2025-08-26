require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest user' do
    let(:user) { nil }

    it { should_not be_able_to(:read, :dashboard) }
    it { should_not be_able_to(:manage, Income) }
    it { should_not be_able_to(:manage, Expense) }
    it { should_not be_able_to(:manage, Category) }
  end

  describe 'for regular user' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }
    let(:own_income) { create(:income, user: user, category: category) }
    let(:own_expense) { create(:expense, user: user, category: category) }
    let(:own_category) { create(:category, user: user) }

    let(:other_user) { create(:user, email: 'other@example.com', username: 'other') }
    let(:other_category) { create(:category, user: other_user) }
    let(:other_income) { create(:income, user: other_user, category: other_category) }
    let(:other_expense) { create(:expense, user: other_user, category: other_category) }

    it { should be_able_to(:read, :dashboard) }

    # Own resources
    it { should be_able_to(:manage, own_income) }
    it { should be_able_to(:manage, own_expense) }
    it { should be_able_to(:manage, own_category) }

    # Other user's resources
    it { should_not be_able_to(:manage, other_income) }
    it { should_not be_able_to(:manage, other_expense) }
    it { should_not be_able_to(:manage, other_category) }
  end

  describe 'for admin user' do
    let(:user) { create(:user, admin: true) }
    let(:other_user) { create(:user, email: 'other@example.com', username: 'other') }
    let(:other_category) { create(:category, user: other_user) }
    let(:other_income) { create(:income, user: other_user, category: other_category) }
    let(:other_expense) { create(:expense, user: other_user, category: other_category) }

    it { should be_able_to(:manage, :all) }
    it { should be_able_to(:manage, other_income) }
    it { should be_able_to(:manage, other_expense) }
    it { should be_able_to(:manage, other_category) }
  end
end

