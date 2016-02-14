class Refund < ActiveRecord::Base
  belongs_to :order
  has_many :refund_line_items
  has_many :transactions
end