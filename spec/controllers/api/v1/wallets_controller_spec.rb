# spec/controllers/api/v1/wallets_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::WalletsController, type: :controller do
  let(:user) { create(:user) }
  let(:wallet) { create(:wallet, owner: user) }
  let(:valid_token) { JwtService.encode(user_id: user.id) }

  before do
    request.headers['Authorization'] = "Bearer #{valid_token}"
  end

  describe "GET #get_balance" do
    context "with valid owner type and wallet exists" do
      let(:params) { { owner: { owner_type: 'User', owner_id: user.id } } }

      it "returns the balance of the wallet" do
        get :get_balance, params: params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["balance"]).to eq(wallet.balance.to_s)
      end
    end

    context "with valid owner type but wallet does not exist" do
      let(:params) { { owner: { owner_type: 'User', owner_id: 9999 } } } # Non-existing user ID

      it "returns a wallet not found error" do
        get :get_balance, params: params
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq('Wallet not found')
      end
    end

    context "with invalid owner type" do
      let(:params) { { owner: { owner_type: 'InvalidType', owner_id: user.id } } }

      it "returns an error for invalid owner type" do
        get :get_balance, params: params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid owner type. Must be one of User, Team, Stock")
      end
    end

    context "when the user is unauthorized" do
      before do
        request.headers['Authorization'] = nil
      end

      let(:params) { { owner: { owner_type: 'User', owner_id: user.id } } }

      it "returns an unauthorized error" do
        get :get_balance, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
