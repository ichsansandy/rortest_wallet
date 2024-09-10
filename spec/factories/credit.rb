FactoryBot.define do
  factory :credit do
    amount { 10.0 }
    transaction_type { 'credit' }
    association :target_wallet, factory: :wallet
  end
end