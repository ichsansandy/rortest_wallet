require 'rails_helper'

RSpec.describe Debit, type: :model do
  let(:wallet) { create(:wallet, :with_transactions) }

  context 'when valid' do
    it 'is valid with valid attributes' do
      debit = build(:debit, source_wallet: wallet, amount: 50.0)
      expect(debit).to be_valid
    end
  end

  context 'when invalid' do
    it 'is invalid if target_wallet is present' do
      # Ensure that the second wallet created here does not conflict with existing ones
      second_wallet = create(:wallet)
      debit = build(:debit, source_wallet: wallet, target_wallet: second_wallet, amount: 50.0)

      expect(debit).not_to be_valid
      expect(debit.errors[:target_wallet]).to include("must be nil for a debit")
    end

    it 'is invalid if amount exceeds the source wallet balance' do
      debit = build(:debit, source_wallet: wallet, amount: 150.0)
      expect(debit).not_to be_valid
      expect(debit.errors[:amount]).to include("cannot be greater than the source wallet's balance")
    end
  end
end
