class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true

  has_many :source_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :target_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'

  def balance
    total_deposits = target_transactions.sum(:amount)
    total_withdrawals = source_transactions.sum(:amount)

    total_deposits - total_withdrawals
  end
end
