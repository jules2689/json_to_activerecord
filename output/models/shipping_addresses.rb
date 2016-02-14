class ShippingAddress < ActiveRecord::Base
  belongs_to :order
end