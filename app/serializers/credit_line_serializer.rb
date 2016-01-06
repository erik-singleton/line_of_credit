class CreditLineSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :description, :balance, :rate, :limit
  has_many :transactions

  def transactions
    object.transactions.order(created_at: :desc, id: :desc)
  end
end
