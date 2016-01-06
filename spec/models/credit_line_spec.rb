describe CreditLine do
  let :user do
    User.create(email: 'an@email.com')
  end

  describe 'with valid params' do
    it 'should be valid' do
      credit_line = CreditLine.create!(user: user, limit: 2000, rate: 0.35, description: 'a description')
      expect(credit_line).to be_valid
    end
  end

  describe 'with invalid params' do
    describe 'without required params' do
      it 'should raise an ActiveRecord::RecordInvalid error' do
        expect { CreditLine.create!(user: user, limit: 2000) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'if it has a balance higher than its limit' do
      it 'should raise an ActiveRecord::RecordInvalid error' do
        credit_line = CreditLine.create(user: user, limit: 1, balance: 2, rate: 0.35)
        expect { credit_line.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
