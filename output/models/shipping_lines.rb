class ShippingLine < ActiveRecord::Base
  belongs_to :order
  has_many :tax_lines
end