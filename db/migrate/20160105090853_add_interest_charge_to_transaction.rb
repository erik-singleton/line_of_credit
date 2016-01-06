class AddInterestChargeToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :interest_charge, :boolean, default: false
  end
end
