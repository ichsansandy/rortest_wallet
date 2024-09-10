# spec/models/wallet_spec.rb
require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe '#balance' do
    let(:user) { create(:user) }
    let(:wallet) { create(:wallet, owner: user) }

    context 'when there are no transactions' do
      it 'returns a balance of 0' do
        expect(wallet.balance).to eq(0.0)
      end
    end

    context 'when there are only credit' do
      before do
        create(:credit, target_wallet: wallet, amount: 100.0)
        create(:credit, target_wallet: wallet, amount: 50.0)
      end

      it 'calculates the correct balance' do
        expect(wallet.balance).to eq(150.0)
      end
    end

    context 'if debit amount greater than amount' do
      it 'it will throw error' do
        expect {
          create(:debit, source_wallet: wallet, amount: 50)
        }.to raise_error(ActiveRecord::RecordInvalid,  "Validation failed: Amount cannot be greater than the source wallet's balance")
      end
    end

    context 'when there are both deposits and withdrawals' do
      before do
        create(:credit, target_wallet: wallet, amount: 150.0)
        create(:debit, source_wallet: wallet, amount: 100.0)
        create(:debit, source_wallet: wallet, amount: 50.0)
      end

      it 'calculates the correct balance' do
        expect(wallet.balance).to eq(150.0 - 100.0 - 50.0)
      end
    end

    context 'when transactions have zero amounts' do
      it 'raises a validation error for zero-amount transactions' do
        expect {
          create(:debit, source_wallet: wallet, amount: 0.0)
        }.to raise_error(ActiveRecord::RecordInvalid, /Amount must be greater than 0/)

        expect {
          create(:credit, target_wallet: wallet, amount: 0.0)
        }.to raise_error(ActiveRecord::RecordInvalid, /Amount must be greater than 0/)
      end
    end

    context 'when there are multiple transactions of the same type' do
      before do
        create(:credit, target_wallet: wallet, amount: 40.0)
        create(:debit, source_wallet: wallet, amount: 30.0)
        create(:credit, target_wallet: wallet, amount: 10.0)
        create(:debit, source_wallet: wallet, amount: 20.0)
      end

      it 'calculates the correct balance' do
        expect(wallet.balance).to eq(40.0 + 10.0 - 30.0 - 20.0)
      end
    end
  end
end
