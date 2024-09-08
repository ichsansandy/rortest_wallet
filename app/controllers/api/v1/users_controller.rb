class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:update_email_and_password]

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

  def update_email_and_password
    if @user.update(email_password_params)
      render json: { success: true, message: 'User updated successfully' }, status: :ok
    else
      render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_user
    @user = User.find(params[:user_id]) # Find user by ID
  end

  def email_password_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
