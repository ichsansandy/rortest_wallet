require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:source_wallet).class_name('Wallet').optional }
    it { should belong_to(:target_wallet).class_name('Wallet').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:transaction_type) }
    it { should allow_value('credit').for(:transaction_type) }
    it { should allow_value('debit').for(:transaction_type) }
    it { should_not allow_value('invalid_type').for(:transaction_type) }
  end

  describe 'custom validations' do
    context 'when transaction_type is credit' do
      it 'is invalid if source_wallet is present' do
        wallet = create(:wallet)
        transaction = build(:transaction, transaction_type: 'credit', source_wallet: wallet)
        expect(transaction).not_to be_valid
        expect(transaction.errors[:source_wallet]).to include("must be nil for credit transactions")
      end

      it 'is valid if source_wallet is nil' do
        transaction = build(:transaction, transaction_type: 'credit', source_wallet: nil)
        expect(transaction).to be_valid
      end
    end

    context 'when transaction_type is debit' do
      it 'is invalid if target_wallet is present' do
        wallet = create(:wallet)
        transaction = build(:transaction, transaction_type: 'debit', target_wallet: wallet)
        expect(transaction).not_to be_valid
        expect(transaction.errors[:target_wallet]).to include("must be nil for debit transactions")
      end

      it 'is valid if target_wallet is nil' do
        transaction = build(:transaction, transaction_type: 'debit', target_wallet: nil)
        expect(transaction).to be_valid
      end
    end
  end
end
