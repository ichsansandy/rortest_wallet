class Debit < Transaction
  before_validation :set_transaction_type

  validate :validate_debit

  private

  def set_transaction_type
    self.transaction_type = 'debit'
  end

  def validate_debit
    errors.add(:target_wallet, "must be nil for a debit") if target_wallet.present?
    errors.add(:source_wallet, "must be present for a debit") if source_wallet.blank?
  end
end