class CreditLineController < ApplicationController
  DEFAULT_LIMIT = 2000
  DEFAULT_RATE = 0.35

  before_filter :require_login

  def index
    credit_lines = CreditLine.where(user_id: @user.id)

    render json: credit_lines, root: false
  end

  def show
    credit_line = CreditLine.find_by!(user_id: @user.id, id: params[:id])

    render json: credit_line
  end

  def create
    credit_line = CreditLine.create!(
      user_id: @user.id,
      description: params[:description],
      limit: params[:limit].andand.to_i || DEFAULT_LIMIT,
      rate: params[:rate].andand.to_d || DEFAULT_RATE
    )

    render json: credit_line, root: false
  end

  def calculate_interest
    credit_line = CreditLine.find_by!(user_id: @user.id, id: params[:id])

    interest_amount = InterestCalculator.new(
      credit_line: credit_line,
      start_date: params[:start_date] || Time.current.last_month.end_of_month,
      end_date: params[:end_date] || Time.current.end_of_month
    ).interest

    transaction = Transaction.find_or_create_by(
      credit_line: credit_line,
      interest_charge: true,
      created_at: Time.now.end_of_month
    )

    transaction.update!(
      amount: interest_amount,
      memo: "Interest Charge for #{Date::MONTHNAMES[Time.now.month]}",
    )

    render json: transaction, root: false
  end
end
