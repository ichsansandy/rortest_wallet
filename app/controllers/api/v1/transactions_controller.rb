class Api::V1::TransactionsController < ApplicationController
  def credit
    target_wallet = Wallet.find(params[:target_wallet_id])
    amount = params[:amount].to_f

    begin
      WalletTransactionService.credit(target_wallet, amount)
      render json: { success: true, message: "Credit successful" }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  def debit
    source_wallet = Wallet.find(params[:source_wallet_id])
    amount = params[:amount].to_f

    begin
      WalletTransactionService.debit(source_wallet, amount)
      render json: { success: true, message: "Debit successful" }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  def transfer
    source_wallet = Wallet.find(params[:source_wallet_id])
    target_wallet = Wallet.find(params[:target_wallet_id])
    amount = params[:amount].to_f

    begin
      WalletTransactionService.transfer(source_wallet, target_wallet, amount)
      render json: { success: true, message: "Transfer successful" }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end
end
