class RefundLineItem < ActiveRecord::Base
  belongs_to :refund
  has_many :line_items
end