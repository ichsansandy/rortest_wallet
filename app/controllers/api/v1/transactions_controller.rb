class Api::V1::TransactionsController < ApplicationController
  before_action :set_source_wallet, only: :debit
  before_action :set_target_wallet, only: :credit
  before_action :set_wallets_for_transfer, only: :transfer

  def credit
    amount = params[:amount].to_f

    begin
      WalletTransactionService.credit(@target_wallet, amount)
      render json: { success: true, message: "Credit successful" }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  def debit
    amount = params[:amount].to_f

    begin
      WalletTransactionService.debit(@source_wallet, amount)
      render json: { success: true, message: "Debit successful" }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  def transfer
    amount = params[:amount].to_f

    begin
      WalletTransactionService.transfer(@source_wallet, @target_wallet, amount)
      render json: { success: true, message: "Transfer successful" }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  private

  def set_source_wallet
    @source_wallet = find_wallet(params[:source_owner_type], params[:source_owner_id])
    return if @source_wallet.present?

    render json: { success: false, message: "Source wallet not found" }, status: :not_found
  end

  def set_target_wallet
    @target_wallet = find_wallet(params[:target_owner_type], params[:target_owner_id])
    return if @target_wallet.present?

    render json: { success: false, message: "Target wallet not found" }, status: :not_found
  end

  def set_wallets_for_transfer
    set_source_wallet
    set_target_wallet
  end

  def find_wallet(owner_type, owner_id)
    owner_class = owner_type.classify.constantize
    owner = owner_class.find(owner_id)
    owner.wallet
  rescue NameError, ActiveRecord::RecordNotFound
    nil
  end
end
