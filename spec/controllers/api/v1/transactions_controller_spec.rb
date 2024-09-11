require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let(:wallet_source)  { create(:wallet, :with_transactions) }
  let(:target_wallet) { create(:wallet) }
  let(:valid_params) { { amount: 10.0, source_owner_type: 'User', source_owner_id: wallet_source.owner_id, target_owner_type: 'User', target_owner_id: target_wallet.owner_id } }

  
  before do
    # Mock token generation
    allow(JwtService).to receive(:encode).and_return('mock_token')
    allow(JwtService).to receive(:decode).and_return({ user_id: wallet_source.owner_id })
    request.headers['Authorization'] = "Bearer mock_token"
  end

  describe 'POST #credit' do
    it 'credits the target wallet successfully' do
     
      post :credit, params: valid_params.merge(target_owner_id: target_wallet.owner_id)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Credit successful')
    end

    # Additional tests for credit action
  end

  describe 'POST #debit' do
  it 'debits the source wallet successfully' do
    user = create(:user, email: "something@mail.com")
    some = user.wallet
    d1 = create(:credit, target_wallet: some, amount: 40)
    post :debit, params: valid_params.merge(source_owner_id: some.owner_id)
    # expect(response).to have_http_status(:ok)
    expect(response.body).to include('Debit successful')
  end

  # Additional tests for debit action
end

  describe 'POST #transfer' do
    it 'transfers between wallets successfully' do
      user = create(:user, email: "something@mail.com")
      some = user.wallet
      d1 = create(:credit, target_wallet: some, amount: 40)
      post :transfer, params: valid_params.merge(source_owner_id: some.owner_id)
      # expect(response).to have_http_status(:ok)
      expect(response.body).to include('Transfer successful')
    end

    # Additional tests for transfer action
  end
end
