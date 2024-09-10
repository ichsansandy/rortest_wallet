require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'after_create callback' do
    let(:stock) { create(:stock) }

    it 'creates a wallet after creating a stock' do
      expect(stock.wallet).not_to be_nil
      expect(stock.wallet.owner).to eq(stock)
    end
  end
end
