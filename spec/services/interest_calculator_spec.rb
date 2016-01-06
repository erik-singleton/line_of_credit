describe InterestCalculator do
  let :user do
    User.create(email: 'an@email.com')
  end

  let :credit_line do
    CreditLine.create(user: user, limit: 2000, rate: 0.35)
  end

  describe 'with only one transaction early in the period' do
    it 'should calculate the correct interest' do
      amount = 500
      period = 30
      interest = amount * (credit_line.rate/365) * period
      Transaction.create!(credit_line: credit_line, amount: amount, created_at: period.days.ago)
      ic = InterestCalculator.new(credit_line: credit_line)
      expect(ic.interest).to eq(interest)
    end
  end

  describe 'with multiple transactions across the period' do
    describe 'in sequence' do
      it 'should calculate the correct interest' do
        transaction_days = [
          { balance: 500, date: 30, active_range: 15, amount: 500 },
          { balance: 300, date: 15, active_range: 10, amount: -200 },
          { balance: 400, date: 5, active_range: 5, amount: 100 }
        ]
        expected_interest = transaction_days.reduce(0) do |interest, transaction| 
          interest + transaction[:balance] * transaction[:active_range] * (credit_line.rate/365)
        end

        transaction_days.each do |t|
          Transaction.create!(credit_line: credit_line, amount: t[:amount], created_at: t[:date].days.ago)
        end

        ic = InterestCalculator.new(credit_line: credit_line)
        expect(ic.interest).to eq(expected_interest)
      end
    end

    describe 'out of sequence' do
      it 'should calculate the correct interest' do
        transaction_days = [
          { balance: 300, date: 15, active_range: 10, amount: -200 },
          { balance: 500, date: 30, active_range: 15, amount: 500 },
          { balance: 400, date: 5, active_range: 5, amount: 100 }
        ]
        expected_interest = transaction_days.reduce(0) do |interest, transaction| 
          interest + transaction[:balance] * transaction[:active_range] * (credit_line.rate/365)
        end

        transaction_days.each do |t|
          Transaction.create!(credit_line: credit_line, amount: t[:amount], created_at: t[:date].days.ago)
        end

        ic = InterestCalculator.new(credit_line: credit_line)
        expect(ic.interest).to eq(expected_interest)
      end
    end
  end
end
