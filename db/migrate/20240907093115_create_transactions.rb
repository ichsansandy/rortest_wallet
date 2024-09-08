class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.references :source_wallet, null: true, foreign_key: { to_table: :wallets }
      t.references :target_wallet, null: true, foreign_key: { to_table: :wallets }
      t.string :transaction_type
      t.string :status

      t.timestamps
    end
  end
end
