class TransactionController < ApplicationController
  def create
    begin
      credit_line = CreditLine.find_by!(user_id: @user.id, id: params[:credit_line_id])
      
      transaction = Transaction.create!(
        credit_line: credit_line,
        amount: params[:amount].to_d,
        memo: params[:memo],
        created_at: Date.parse(params[:created_at])
      )

      render json: transaction, root: false
    rescue ActiveRecord::RecordInvalid
      render json: { error: 'invalid' },
             status: 500
    end
  end
end
