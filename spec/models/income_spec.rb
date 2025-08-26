require 'rails_helper'

RSpec.describe Income, type: :model do
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
    expect(FactoryBot.build(:income)).to be_valid
  end

  # Testes de escopo e métodos
  describe 'scopes' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }
    let!(:income1) { create(:income, user: user, category: category, amount: 100.0, date: 1.day.ago) }
    let!(:income2) { create(:income, user: user, category: category, amount: 200.0, date: 2.days.ago) }

    it 'orders by date descending with recent scope' do
      recent_incomes = Income.where(user: user).recent
      expect(recent_incomes.first).to eq(income1)
      expect(recent_incomes.second).to eq(income2)
    end
  end

  # Testes de validação de dados
  describe 'validations' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }

    it 'is invalid with negative amount' do
      income = build(:income, user: user, category: category, amount: -10.0)
      expect(income).not_to be_valid
    end

    it 'is invalid with zero amount' do
      income = build(:income, user: user, category: category, amount: 0.0)
      expect(income).not_to be_valid
    end

    it 'is valid with positive amount' do
      income = build(:income, user: user, category: category, amount: 100.0)
      expect(income).to be_valid
    end

    it 'is invalid without description' do
      income = build(:income, user: user, category: category, description: nil)
      expect(income).not_to be_valid
    end

    it 'is invalid without date' do
      income = build(:income, user: user, category: category, date: nil)
      expect(income).not_to be_valid
    end
  end

  # Testes para Active Storage (receipt)
  describe 'receipt attachment' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }
    let(:income) { create(:income, user: user, category: category) }

    it 'can attach a receipt' do
      income.receipt.attach(
        io: StringIO.new("test"), 
        filename: "receipt.jpg", 
        content_type: "image/jpeg"
      )
      expect(income.receipt).to be_attached
    end

    it 'has_receipt? returns true when receipt is attached' do
      income.receipt.attach(
        io: StringIO.new("test"), 
        filename: "receipt.jpg", 
        content_type: "image/jpeg"
      )
      expect(income.has_receipt?).to be true
    end

    it 'has_receipt? returns false when no receipt is attached' do
      expect(income.has_receipt?).to be false
    end

    it 'returns receipt URL when attached' do
      income.receipt.attach(
        io: StringIO.new("test"), 
        filename: "receipt.jpg", 
        content_type: "image/jpeg"
      )
      expect(income.receipt_url).to include('rails/active_storage/blobs')
    end

    it 'returns nil for receipt URL when not attached' do
      expect(income.receipt_url).to be_nil
    end

    describe 'receipt validation' do
      it 'accepts valid image types' do
        %w[image/jpeg image/jpg image/png].each do |content_type|
          income.receipt.attach(
            io: StringIO.new("test"), 
            filename: "receipt.#{content_type.split('/').last}", 
            content_type: content_type
          )
          expect(income).to be_valid
          income.receipt.detach
        end
      end

      it 'accepts PDF files' do
        income.receipt.attach(
          io: StringIO.new("test"), 
          filename: "receipt.pdf", 
          content_type: "application/pdf"
        )
        expect(income).to be_valid
      end

      it 'rejects invalid file types' do
        income.receipt.attach(
          io: StringIO.new("test"), 
          filename: "receipt.txt", 
          content_type: "text/plain"
        )
        expect(income).not_to be_valid
        expect(income.errors[:receipt]).to include('deve ser uma imagem ou PDF')
      end

      it 'rejects files larger than 5MB' do
        allow_any_instance_of(ActiveStorage::Blob).to receive(:byte_size).and_return(6.megabytes)
        income.receipt.attach(
          io: StringIO.new("test"), 
          filename: "receipt.jpg", 
          content_type: "image/jpeg"
        )
        expect(income).not_to be_valid
        expect(income.errors[:receipt]).to include('deve ter menos de 5MB')
      end
    end
  end
end
