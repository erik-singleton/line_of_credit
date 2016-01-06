class SetDefaultForCreditLimitBalance < ActiveRecord::Migration
  def change
    change_column :credit_lines, :balance, :integer, default: 0
  end
end
