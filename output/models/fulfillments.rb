class Fulfillment < ActiveRecord::Base
  belongs_to :order
  has_many :line_items
  has_many :tracking_numbers
  has_many :tracking_urls
  has_one :receipt
end