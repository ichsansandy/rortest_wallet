require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user, password: 'password123') }

  describe 'POST #create' do
    context 'with valid credentials' do
      before do
        post :create, params: { email: user.email, password: 'password123' }
      end

      it 'returns a JWT token' do
        expect(response).to have_http_status(:ok)
        expect(json_response['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      before do
        post :create, params: { email: user.email, password: 'wrongpassword' }
      end

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid email or password')
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
