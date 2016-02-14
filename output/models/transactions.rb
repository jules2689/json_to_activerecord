class Transaction < ActiveRecord::Base
  belongs_to :refund
  has_many :receipts
end