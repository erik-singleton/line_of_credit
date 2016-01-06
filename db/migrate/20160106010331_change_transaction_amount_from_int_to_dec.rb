class ChangeTransactionAmountFromIntToDec < ActiveRecord::Migration
  def change
    change_column :transactions, :amount, :decimal, default: 0
  end
end
