# spec/factories/transactions.rb

FactoryBot.define do
  factory :transaction do
    amount { 100.0 }
    transaction_type { 'credit' } # Default to 'credit'; override in specific factories

    factory :credit_transaction do
      transaction_type { 'credit' }
      association :target_wallet, factory: :wallet
    end

    factory :debit_transaction do
      transaction_type { 'debit' }
      association :source_wallet, factory: :wallet
    end
  end
end
