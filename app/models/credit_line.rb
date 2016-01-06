class CreditLine < ActiveRecord::Base
  belongs_to :user
  has_many :transactions

  validates :rate, :limit, :user_id, presence: true
  validates :balance,
    numericality: { less_than_or_equal_to: :limit },
    format: { with: /\d{0,5}(\.\d{0,2})?/ }

  def recalculate_transaction_balances
    self.balance = 0

    trans = transactions.order(created_at: :asc)
    trans.each do |transaction|
      transaction.update_balance
      transaction.save!
    end
  end
end
