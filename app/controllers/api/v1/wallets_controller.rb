class Api::V1::WalletsController < ApplicationController
  before_action :validate_owner_type, only: :get_balance

  def get_balance
    owner_type = params[:owner][:owner_type].classify
    owner_id = params[:owner][:owner_id]

    wallet = Wallet.find_by(owner_type: owner_type, owner_id: owner_id)

    if wallet
      render json: { balance: wallet.balance }, status: :ok
    else
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end

  private

  def validate_owner_type
    valid_owner_types = ["User", "Team", "Stock"]

    unless valid_owner_types.include?(params[:owner][:owner_type])
      render json: { error: "Invalid owner type. Must be one of #{valid_owner_types.join(', ')}" }, status: :unprocessable_entity
    end
  end

  def owner_params
    params.require(:owner).permit(:owner_type, :owner_id)
  end
end
