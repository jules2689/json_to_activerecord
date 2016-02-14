class Order < ActiveRecord::Base
  has_many :discount_codes
  has_many :note_attributes
  has_many :tax_lines
  has_many :line_items
  has_many :shipping_lines
  has_many :billing_addresses
  has_many :shipping_addresses
  has_many :fulfillments
  has_many :client_details
  has_many :refunds
  has_many :payment_details
  has_many :customers
end