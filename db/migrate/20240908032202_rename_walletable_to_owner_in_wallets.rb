class RenameWalletableToOwnerInWallets < ActiveRecord::Migration[7.2]
  def change
    rename_column :wallets, :walletable_type, :owner_type
    rename_column :wallets, :walletable_id, :owner_id
  end
end
