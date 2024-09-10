FactoryBot.define do
  factory :debit do
    amount { 10.0 }
    transaction_type { 'debit' }
    association :source_wallet, factory: :wallet
  end
end