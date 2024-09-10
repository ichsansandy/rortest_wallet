require 'rails_helper'

RSpec.describe WalletTransactionService, type: :service do
  let(:source_wallet) { create(:wallet, :for_trx_service) }
  let(:target_wallet) { create(:wallet) }

  describe '.credit' do
    it 'creates a credit transaction' do
      expect {
        WalletTransactionService.credit(target_wallet, 50.0)
      }.to change { Transaction.count }.by(1)

      transaction = Transaction.last
      expect(transaction.transaction_type).to eq('credit')
      expect(transaction.target_wallet).to eq(target_wallet)
    end
  end

  describe '.debit' do
    context 'when there are sufficient funds' do
      it 'creates a debit transaction' do
        expect {
          WalletTransactionService.debit(source_wallet, 50.0)
        }.to change { Transaction.count }.by(2)  # 1 + initial credit

        transaction = Transaction.last
        expect(transaction.transaction_type).to eq('debit')
        expect(transaction.source_wallet).to eq(source_wallet)
      end
    end

    context 'when there are insufficient funds' do
      it 'raises an error' do
        expect {
          WalletTransactionService.debit(source_wallet, 200.0)
        }.to raise_error(StandardError, 'Insufficient funds')
      end
    end
  end

  describe '.transfer' do
    context 'when there are sufficient funds' do
      it 'transfers amount from source to target wallet' do
        expect {
          WalletTransactionService.transfer(source_wallet, target_wallet, 50.0)
        }.to change { Transaction.count }.by(3) # One debit, one credit + initial credit

        expect(source_wallet.reload.balance).to eq(50.0)
        expect(target_wallet.reload.balance).to eq(50.0)
      end
    end

    context 'when there are insufficient funds' do
      it 'raises an error' do
        expect {
          WalletTransactionService.transfer(source_wallet, target_wallet, 200.0)
        }.to raise_error(StandardError, 'Insufficient funds')
      end
    end
  end
end
