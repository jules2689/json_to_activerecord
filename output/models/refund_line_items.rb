class RefundLineItem < ActiveRecord::Base
  belongs_to :refund
  has_one :line_item
end