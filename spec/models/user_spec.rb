require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should have_secure_password }
    it { should have_one(:wallet).dependent(:destroy) }
  end

  describe 'after_create callback' do
    let(:user) { create(:user) }

    it 'creates a wallet after creating a user' do
      expect(user.wallet).not_to be_nil
      expect(user.wallet.owner).to eq(user)
    end
  end
end