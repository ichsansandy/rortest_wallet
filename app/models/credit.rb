class Credit < Transaction
  before_validation :set_transaction_type

  validate :validate_credit

  private

  def set_transaction_type
    self.transaction_type = 'credit'
  end

  def validate_credit
    errors.add(:source_wallet, "must be nil for a credit") if source_wallet.present?
    errors.add(:target_wallet, "must be present for a credit") if target_wallet.blank?
  end
end