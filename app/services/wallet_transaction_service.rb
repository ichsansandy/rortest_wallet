class WalletTransactionService
  def self.credit(target_wallet, amount)
    ActiveRecord::Base.transaction do
      Transaction.create!(
        amount: amount,
        target_wallet: target_wallet,
        transaction_type: 'credit',
      )
    end
  end

  def self.debit(source_wallet, amount)
    raise ActiveRecord::RecordInvalid, "Insufficient funds" if source_wallet.balance < amount

    ActiveRecord::Base.transaction do
      Transaction.create!(
        amount: amount,
        source_wallet: source_wallet,
        transaction_type: 'debit',
      )
    end
  end

  def self.transfer(source_wallet, target_wallet, amount)
    ActiveRecord::Base.transaction do
      # Debit from the source wallet
      debit(source_wallet, amount)

      # Credit to the target wallet
      credit(target_wallet, amount)
    end
  end
end
