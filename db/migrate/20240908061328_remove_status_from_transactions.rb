class RemoveStatusFromTransactions < ActiveRecord::Migration[7.2]
  def change
    remove_column :transactions, :status, :string
  end
end
