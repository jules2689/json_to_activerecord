class Fulfillment < ActiveRecord::Base
  belongs_to :order
  has_many :tracking_numbers
  has_many :tracking_urls
  has_many :receipts
  has_many :line_items
end