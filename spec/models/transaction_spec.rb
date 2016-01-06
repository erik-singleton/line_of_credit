describe Transaction do
  let :user do
    User.create(email: 'an@email.com')
  end

  let :credit_line do
    CreditLine.create(user: user, limit: 2000, rate: 0.35)
  end

  describe 'with valid params' do
    it 'should be valid' do
      transaction = Transaction.create!(credit_line: credit_line, amount: 50)
      expect(transaction).to be_valid
    end

    describe 'if a transaction takes a CreditLine balance to < 0' do
      it 'should be valid' do
        transaction = Transaction.create!(credit_line: credit_line, amount: -50)
        expect(transaction).to be_valid
      end
    end
  end

  describe 'with invalid params' do
    describe 'if a transaction takes a CreditLine balance to > its limit' do
      it 'should raise an ActiveRecord::RecordInvalid error' do
        transaction = Transaction.create(credit_line: credit_line, amount: credit_line.limit+1)
        expect { transaction.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'if a transaction is inserted between two transactions' do
    before do
      allow_any_instance_of(CreditLine).to receive(:recalculate_transaction_balances).and_call_original
    end

    it 'should call #update_neighbors' do
      transactions = [
        { amount: 30, date: 3.days.ago },
        { amount: 30, date: 6.days.ago },
        { amount: -25, date: 5.days.ago }
      ]
      transactions.each do |t|
        Transaction.create!(credit_line: credit_line, amount: t[:amount], created_at: t[:date])
      end
      
      expect(credit_line).to have_received(:recalculate_transaction_balances).at_least(:once)
    end

    it 'should recalculate the balances correctly according to created_at' do
      transactions = [
        { amount: 30, date: 3.days.ago },
        { amount: 30, date: 6.days.ago },
        { amount: -25, date: 5.days.ago }
      ]
      transactions.each do |t|
        Transaction.create!(credit_line: credit_line, amount: t[:amount], created_at: t[:date])
      end
      
      expect(credit_line.balance).to eq(transactions.reduce(0) { |s, t| s + t[:amount] })
      credit_line.transactions.order(created_at: :asc).each_cons(2) do |earlier_t, later_t|
        expect(later_t.previous_balance).to eq(earlier_t.balance)
      end
    end
  end
end
