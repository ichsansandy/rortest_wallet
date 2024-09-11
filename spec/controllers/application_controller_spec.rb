# spec/controllers/application_controller_spec.rb
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :authorize_request

    def index
      render json: { success: true }
    end
  end

  let(:user) { create(:user) }
  let(:valid_token) { JwtService.encode(user_id: user.id) }
  let(:invalid_token) { 'invalidtoken' }

  describe "#authorize_request" do
    context "when the Authorization header is missing" do
      it "returns an unauthorized response" do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["errors"]).to eq("Incorrect token prefix")
      end
    end

    context "when the Authorization header has an invalid prefix" do
      before { request.headers['Authorization'] = "Token #{valid_token}" }

      it "returns an unauthorized response due to incorrect prefix" do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["errors"]).to eq("Incorrect token prefix")
      end
    end

    context "when the token is invalid" do
      before { request.headers['Authorization'] = "Bearer #{invalid_token}" }

      it "returns an unauthorized response for an invalid token" do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["errors"]).to eq("Invalid token")
      end
    end

    context "when the token is valid" do
      before { request.headers['Authorization'] = "Bearer #{valid_token}" }

      it "authorizes the request successfully" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["success"]).to be_truthy
      end
    end

    context "when the user is not found" do
      before do
        allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound, "User not found")
        request.headers['Authorization'] = "Bearer #{valid_token}"
      end

      it "returns an unauthorized response with a user not found error" do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["errors"]).to eq("User not found")
      end
    end

    context "when the token is expired" do
      let(:expired_token) { JwtService.encode({ user_id: user.id }, 25.hours.ago) }

      before { request.headers['Authorization'] = "Bearer #{expired_token}" }

      it "returns an unauthorized response for expired token" do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["errors"]).to eq("Invalid token")
      end
    end
  end
end
