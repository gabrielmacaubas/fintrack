require 'rails_helper'

RSpec.describe Category, type: :model do
  # Testes de associação
  it { should belong_to(:user) }
  it { should have_many(:incomes).dependent(:destroy) }
  it { should have_many(:expenses).dependent(:destroy) }

  # Testes de validação
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }

  # Teste de factory válida
  it 'should have a valid factory' do
    expect(FactoryBot.build(:category)).to be_valid
  end

  # Testes de validação de dados
  describe 'validations' do
    let(:user) { create(:user) }

    it 'is valid with a name and user' do
      category = build(:category, user: user, name: 'Alimentação')
      expect(category).to be_valid
    end

    it 'is invalid without a name' do
      category = build(:category, user: user, name: nil)
      expect(category).not_to be_valid
    end

    it 'is invalid without a user' do
      category = build(:category, user: nil, name: 'Alimentação')
      expect(category).not_to be_valid
    end

    it 'allows duplicate names for different users' do
      user1 = create(:user)
      user2 = create(:user, email: 'user2@example.com', username: 'user2')
      
      category1 = create(:category, user: user1, name: 'Alimentação')
      category2 = build(:category, user: user2, name: 'Alimentação')
      
      expect(category2).to be_valid
    end

    it 'does not allow duplicate names for the same user' do
      user = create(:user)
      create(:category, user: user, name: 'Alimentação')
      
      duplicate_category = build(:category, user: user, name: 'Alimentação')
      expect(duplicate_category).not_to be_valid
    end
  end

  # Testes de escopo
  describe 'scopes' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user, email: 'user2@example.com', username: 'user2') }
    let!(:category1) { create(:category, user: user1, name: 'Categoria 1') }
    let!(:category2) { create(:category, user: user2, name: 'Categoria 2') }

    it 'returns categories for specific user' do
      expect(user1.categories).to include(category1)
      expect(user1.categories).not_to include(category2)
    end
  end
end
