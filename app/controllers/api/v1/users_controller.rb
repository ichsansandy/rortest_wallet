class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    
    if user.save
      render json: { message: 'User created successfully', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def get_balance
    # Find the user based on params (assuming the user is authenticated or passed via params)
    user = User.find(params[:user_id])

    # Fetch the associated wallet balance
    if user.wallet
      render json: { balance: user.wallet.balance }, status: :ok
    else
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
