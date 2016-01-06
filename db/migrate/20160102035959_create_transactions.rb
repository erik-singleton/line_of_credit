class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :credit_line_id
      t.string :memo
      t.integer :amount
      t.integer :balance

      t.timestamps null: false
    end
  end
end
