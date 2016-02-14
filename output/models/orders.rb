class Order < ActiveRecord::Base
  has_many :discount_codes
  has_many :fulfillments
  has_many :line_items
  has_many :note_attributes
  has_many :refunds
  has_many :shipping_lines
  has_many :tax_lines
  has_one :billing_address
  has_one :client_detail
  has_one :customer
  has_one :payment_detail
  has_one :shipping_address
end