class ChangeCreditLineBalanceFromIntToDec < ActiveRecord::Migration
  def change
    change_column :credit_lines, :balance, :decimal, default: 0
  end
end
