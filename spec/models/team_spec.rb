require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'after_create callback' do
    let(:team) { create(:team) }

    it 'creates a wallet after creating a team' do
      expect(team.wallet).not_to be_nil
      expect(team.wallet.owner).to eq(team)
    end
  end
end
