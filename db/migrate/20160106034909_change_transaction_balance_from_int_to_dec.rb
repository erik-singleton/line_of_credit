class ChangeTransactionBalanceFromIntToDec < ActiveRecord::Migration
  def change
    change_column :transactions, :balance, :decimal, default: 0
  end
end
