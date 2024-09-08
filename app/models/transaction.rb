class Transaction < ApplicationRecord
  self.inheritance_column = :type

  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true

  validate :validate_transaction

  TRANSACTION_TYPES = %w[credit debit].freeze

  private

  def validate_transaction
    if transaction_type == 'credit' && source_wallet.present?
      errors.add(:source_wallet, "must be nil for credit transactions")
    elsif transaction_type == 'debit' && target_wallet.present?
      errors.add(:target_wallet, "must be nil for debit transactions")
    end
  end
end
