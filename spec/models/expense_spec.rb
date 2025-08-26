require 'rails_helper'

RSpec.describe Expense, type: :model do
  # Testes de associação
  it { should belong_to(:user) }
  it { should belong_to(:category) }
  it { should have_one_attached(:receipt) }

  # Testes de validação
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:description) }

  # Teste de validação numérica
  it { should validate_numericality_of(:amount).is_greater_than(0) }

  # Teste de factory válida
  it 'should have a valid factory' do
    expect(FactoryBot.build(:expense)).to be_valid
  end

  # Testes de escopo e métodos
  describe 'scopes' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }
    let!(:expense1) { create(:expense, user: user, category: category, amount: 50.0, date: 1.day.ago) }
    let!(:expense2) { create(:expense, user: user, category: category, amount: 75.0, date: 2.days.ago) }

    it 'orders by date descending with recent scope' do
      recent_expenses = Expense.where(user: user).recent
      expect(recent_expenses.first).to eq(expense1)
      expect(recent_expenses.second).to eq(expense2)
    end
  end

  # Testes de validação de dados
  describe 'validations' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }

    it 'is invalid with negative amount' do
      expense = build(:expense, user: user, category: category, amount: -10.0)
      expect(expense).not_to be_valid
    end

    it 'is invalid with zero amount' do
      expense = build(:expense, user: user, category: category, amount: 0.0)
      expect(expense).not_to be_valid
    end

    it 'is valid with positive amount' do
      expense = build(:expense, user: user, category: category, amount: 50.0)
      expect(expense).to be_valid
    end

    it 'is invalid without description' do
      expense = build(:expense, user: user, category: category, description: nil)
      expect(expense).not_to be_valid
    end

    it 'is invalid without date' do
      expense = build(:expense, user: user, category: category, date: nil)
      expect(expense).not_to be_valid
    end
  end

  # Testes para Active Storage (receipt)
  describe 'receipt attachment' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }
    let(:expense) { create(:expense, user: user, category: category) }

    it 'can attach a receipt' do
      expense.receipt.attach(
        io: StringIO.new("test"), 
        filename: "receipt.jpg", 
        content_type: "image/jpeg"
      )
      expect(expense.receipt).to be_attached
    end

    it 'has_receipt? returns true when receipt is attached' do
      expense.receipt.attach(
        io: StringIO.new("test"), 
        filename: "receipt.jpg", 
        content_type: "image/jpeg"
      )
      expect(expense.has_receipt?).to be true
    end

    it 'has_receipt? returns false when no receipt is attached' do
      expect(expense.has_receipt?).to be false
    end

    it 'returns receipt URL when attached' do
      expense.receipt.attach(
        io: StringIO.new("test"), 
        filename: "receipt.jpg", 
        content_type: "image/jpeg"
      )
      expect(expense.receipt_url).to include('rails/active_storage/blobs')
    end

    it 'returns nil for receipt URL when not attached' do
      expect(expense.receipt_url).to be_nil
    end

    describe 'receipt validation' do
      it 'accepts valid image types' do
        %w[image/jpeg image/jpg image/png].each do |content_type|
          expense.receipt.attach(
            io: StringIO.new("test"), 
            filename: "receipt.#{content_type.split('/').last}", 
            content_type: content_type
          )
          expect(expense).to be_valid
          expense.receipt.detach
        end
      end

      it 'accepts PDF files' do
        expense.receipt.attach(
          io: StringIO.new("test"), 
          filename: "receipt.pdf", 
          content_type: "application/pdf"
        )
        expect(expense).to be_valid
      end

      it 'rejects invalid file types' do
        expense.receipt.attach(
          io: StringIO.new("test"), 
          filename: "receipt.txt", 
          content_type: "text/plain"
        )
        expect(expense).not_to be_valid
        expect(expense.errors[:receipt]).to include('deve ser uma imagem ou PDF')
      end

      it 'rejects files larger than 5MB' do
        allow_any_instance_of(ActiveStorage::Blob).to receive(:byte_size).and_return(6.megabytes)
        expense.receipt.attach(
          io: StringIO.new("test"), 
          filename: "receipt.jpg", 
          content_type: "image/jpeg"
        )
        expect(expense).not_to be_valid
        expect(expense.errors[:receipt]).to include('deve ter menos de 5MB')
      end
    end
  end
end
