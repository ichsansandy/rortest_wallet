# spec/factories/wallets.rb
FactoryBot.define do
  factory :wallet do
    association :owner, factory: :user # Adjust this if you need different associations

    # Define traits if you need specific types of wallets
    trait :with_transactions do
      after(:create) do |wallet|
        create(:credit, target_wallet: wallet, amount: 130.0)
      end
    end
  end
end
