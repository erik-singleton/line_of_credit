class AddLockVersionToCreditLine < ActiveRecord::Migration
  def change
    add_column :credit_lines, :lock_version, :integer
  end
end
