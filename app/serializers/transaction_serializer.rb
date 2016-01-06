class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :memo, :balance, :interest_charge, :created_at
end
