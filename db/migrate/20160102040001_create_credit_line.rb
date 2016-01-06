class CreateCreditLine < ActiveRecord::Migration
  def change
    create_table :credit_lines do |t|
      t.integer :user_id
      t.integer :balance
      t.decimal :rate
      t.text :description

      t.timestamps null: false
    end
  end
end
