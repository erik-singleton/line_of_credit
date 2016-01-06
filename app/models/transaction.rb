class Transaction < ActiveRecord::Base
  MAX_RETRIES = 3

  belongs_to :credit_line

  before_create :update_balance
  after_create :update_neighbors, if: -> { next? }
  before_update :recalculate_balance

  def previous_balance
    balance - amount
  end

  def update_balance
    return unless amount

    tries ||= MAX_RETRIES

    begin
      self.balance = credit_line.balance + amount
      credit_line.balance = balance
      credit_line.save!
    rescue ActiveRecord::StaleObjectError
      retry unless (tries -= 1).zero?
    end
  end

  private
  
  def next?
    credit_line.transactions.where('created_at > ?', created_at).any?
  end

  def previous?
    credit_line.transactions.where('created_at < ?', created_at).any?
  end

  def update_neighbors
    credit_line.recalculate_transaction_balances
  end

  def recalculate_balance
    return unless amount

    tries ||= MAX_RETRIES
    
    begin
      self.balance = credit_line.balance + amount - amount_was.to_d
      credit_line.update_columns(balance: balance)
    rescue ActiveRecord::StaleObjectError
      retry unless (tries -= 1).zero?
    end
  end
end
