class Transaction < ActiveRecord::Base
  belongs_to :refund
  has_one :receipt
end