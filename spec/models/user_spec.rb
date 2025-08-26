require 'rails_helper'

RSpec.describe User, type: :model do
  # Testes de validação
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }

  # Teste de unicidade do username
  context 'uniqueness' do
    before { create(:user) }
    it { should validate_uniqueness_of(:username).case_insensitive }
  end

  # Testes de associação
  it { should have_many(:incomes).dependent(:destroy) }
  it { should have_many(:expenses).dependent(:destroy) }
  it { should have_many(:categories).dependent(:destroy) }

  # Teste de factory válida
  it 'should have a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # Testes de métodos
  describe '#full_name' do
    let(:user) { build(:user, first_name: 'João', last_name: 'Silva') }

    it 'returns the full name' do
      expect(user.full_name).to eq('João Silva')
    end
  end

  # Testes de campo admin
  describe '#admin' do
    it 'defaults to false' do
      user = User.new
      expect(user.admin).to be_falsey
    end

    it 'can be set to true' do
      user = build(:user, admin: true)
      expect(user.admin).to be_truthy
    end
  end

  # Testes de validação de email (Devise)
  describe 'email validation' do
    it 'is invalid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid with an invalid email format' do
      user = build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
    end

    it 'is valid with a valid email format' do
      user = build(:user, email: 'test@example.com')
      expect(user).to be_valid
    end
  end
end

