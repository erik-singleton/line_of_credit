class AddLimitToCreditLine < ActiveRecord::Migration
  def change
    add_column :credit_lines, :limit, :integer
  end
end
