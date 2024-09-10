require 'rails_helper'

RSpec.describe Credit, type: :model do
  let(:wallet) { create(:wallet) }

  context 'validations' do
    it 'is invalid if source_wallet is present' do
      credit = build(:credit, source_wallet: wallet, target_wallet: create(:wallet), amount: 50.0)
      expect(credit).not_to be_valid
      expect(credit.errors[:source_wallet]).to include("must be nil for a credit")
    end

    it 'is invalid if target_wallet is not present' do
      credit = build(:credit, source_wallet: nil, target_wallet: nil, amount: 50.0)
      expect(credit).not_to be_valid
      expect(credit.errors[:target_wallet]).to include("must be present for a credit")
    end

    it 'is valid if target_wallet is present and source_wallet is nil' do
      credit = build(:credit, source_wallet: nil, target_wallet: create(:wallet), amount: 50.0)
      expect(credit).to be_valid
    end
  end
end
