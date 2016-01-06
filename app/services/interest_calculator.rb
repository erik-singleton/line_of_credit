class InterestCalculator
  DEFAULT_START_DATE = 30.days.ago.at_midnight
  DEFAULT_END_DATE = Time.now
  DAYS_PER_YEAR = 365

  attr_reader :credit_line, :start_date, :end_date

  def initialize(credit_line:, start_date: DEFAULT_START_DATE, end_date: DEFAULT_END_DATE)
    @credit_line = credit_line
    @start_date = start_date
    @end_date = end_date
  end

  def interest
    return 0 if transactions.empty?

    transaction_balances.zip(transaction_deltas).reduce(0.0) do |acc, (balance, days_active)|
      acc + (balance * apr * days_active)
    end
  end

  private

  def transactions
    @transactions ||= credit_line
      .transactions
      .where(created_at: start_date..end_date, interest_charge: false)
      .order(created_at: :asc)
  end

  def transaction_deltas
    @transaction_deltas ||= [].tap do |array|
      transaction_dates.each_cons(2) do |earlier_transaction, later_transaction|
        delta = later_transaction - earlier_transaction
        delta_to_days = (delta / 1.day).round
        array.push(delta_to_days)
      end
    end
  end

  def transaction_dates
    transactions.map(&:created_at).unshift(start_date).push(end_date)
  end

  def transaction_balances
    transactions.map(&:balance).unshift(starting_balance)
  end

  def starting_balance
    transactions.first.previous_balance
  end

  def apr
    @apr ||= credit_line.rate / 365.0
  end
end
