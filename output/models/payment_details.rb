class PaymentDetail < ActiveRecord::Base
  belongs_to :order
end